//
//  WebClient.swift
//  Donando
//
//  Created by Halil Gursoy on 29/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import Alamofire
import BrightFutures
import Result

class WebClient {

    static let RequestTimeOut: NSTimeInterval = 60.seconds
    let manager: Alamofire.Manager
    
    static func createManager() -> Alamofire.Manager {
        var defaultHeaders = Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders ?? [:]
        defaultHeaders["Content-Type"] = "application/json"
        defaultHeaders["Accept"] = "application/json"
        defaultHeaders["CLIENT_TYPE"] = "ios-app"
        defaultHeaders["Cache-Control"] = "no-cache, no-store, must-revalidate"
        defaultHeaders["Pragma"] = "no-cache"
        defaultHeaders["Expires"] = "0"
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = defaultHeaders
        
        return Alamofire.Manager(configuration: configuration)
    }
    
    init(manager: Alamofire.Manager? = nil) {
        self.manager = manager ?? WebClient.createManager()
    }
    
    func createRequest(API name: APIName, endpointPath: EndpointPath, ids: [Token:String]? = nil, queryItems: [NSURLQueryItem]? = nil, json: NSData? = nil, method: HTTPMethod = .GET, authenticate: Bool = true, cache: Bool = false) -> NSURLRequest {
        
        let fullURLString = Endpoints.URLString(APIName: name, path: endpointPath, ids: ids, queryItems: queryItems)
        let url = NSURL(string: fullURLString)!
        let cachePolicy: NSURLRequestCachePolicy = .ReloadIgnoringLocalCacheData
        
        var request = NSMutableURLRequest(URL: url, cachePolicy: cachePolicy, timeoutInterval: WebClient.RequestTimeOut)
        // On some devices for some reason the content-type header is not set to "Application/JSON" so a bad request error is returned.e
        // This fixes the header issue
        if let json = json {
            let newRequest = ParameterEncoding.JSON.encode(request, parameters:(try? NSJSONSerialization.JSONObjectWithData(json, options: [])) as? [String: AnyObject]).0
            request = newRequest.copy() as! NSMutableURLRequest
        }
        
        request.HTTPMethod = method.rawValue
        request.HTTPBody = json
        request.timeoutInterval = WebClient.RequestTimeOut
        
        return request
    }
    
    /**
     Send a previously created NSURLRequest, through AlamoFire. This method also handles the response, by checking errors and creating a PagedResult, and calls the completion closure
     
     - parameter request:       The NSURLRequest to be sent
     */
    func sendRequest(request: NSURLRequest) -> DataResult {
        let promise = Promise<AnyObject?, DonandoError> ()
        
        manager.request(request).responseJSON(options: []) { response in
            guard let _ = response.request else { return }
            
            if response.result.isSuccess {
                promise.success(response.result.value)
            } else {
                promise.failure(DonandoError.GenericError)
            }
            
        }.validate()
        
        return promise.future
    }
}

public typealias Token = String
public typealias EndpointPath = String
public typealias Parameter = String

public enum APIName: EndpointPath {
    
    case NGOs = "ngos"
    case Demands = "demands"
}

public struct Endpoints {
    
    public static var baseURI: String!
    
    public static let ngoIdToken: Token = "ngoId"
    public static let demandIdToken: Token = "demandId"
    public static let zipCodeToken: Token = "address"
    public static let searchTextToken: Token = "filter"
    
    public static let ngoNear: EndpointPath = ""
    public static let demandSearch: EndpointPath = "search"
    

    public static func URLString(baseURI: String? = nil, APIName name: APIName, path: EndpointPath, ids:[Token:String]?, queryItems: [NSURLQueryItem]? = nil) -> String {
        
        // convert baseURI string to NSURL to avoid cropping of protocol information:
        
        let baseURLString = baseURI == nil ? self.baseURI : baseURI
        var baseURL = NSURL(string: baseURLString)
        // appended path components will be URL encoded automatically:
        baseURL = baseURL!.URLByAppendingPathComponent(name.rawValue).URLByAppendingPathComponent(path)
        // re-decode URL components so token placeholders can be replaced later:
        var populatedEndPoint: String = baseURL!.absoluteString.stringByRemovingPercentEncoding!
        
        if let replacements = ids {
            for (token, value) in replacements {
                populatedEndPoint = populatedEndPoint.stringByReplacingOccurrencesOfString(token, withString: value)
            }
        }
        
        if let urlComponents = NSURLComponents(string: populatedEndPoint) {
            urlComponents.queryItems = queryItems
            return urlComponents.URLString
        }
        
        return populatedEndPoint
    }
}

private extension String {
    func stringByAppendingPathComponent(comp: String) -> String {
        return self + "/" + comp
    }
}

public enum HTTPMethod: String {
    case OPTIONS, GET, HEAD, POST, PUT, PATCH, DELETE, TRACE, CONNECT
}