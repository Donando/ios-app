//
//  APIClient.swift
//  Donando
//
//  Created by Halil Gursoy on 29/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import BrightFutures

public class APIClient: DataClient {
    
    let webClient = WebClient()
    
    public func getNGOs(zipCode: String, searchText: String) -> DataResult {
        var tokens = [String: String]()
        
        if zipCode.characters.count > 0 {
            tokens[Endpoints.zipCodeToken] = zipCode
        }
        if searchText.characters.count > 0 {
            tokens[Endpoints.searchTextToken] = searchText
        }
        
        let queryItems = createQueryItems(tokens)
        
        let request = webClient.createRequest(API: APIName.Demands, endpointPath: Endpoints.demandSearch, queryItems: queryItems)
        return webClient.sendRequest(request)
    }
    
    private func createQueryItems(items: [String: String]) -> [NSURLQueryItem] {
        var queryItems = [NSURLQueryItem]()
        
        for key in items.keys {
            let queryItem = NSURLQueryItem(name: key, value: items[key])
            queryItems.append(queryItem)
        }
        
        return queryItems
    }
    
}