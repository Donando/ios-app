//
//  DataStore.swift
//  Donando
//
//  Created by Halil Gursoy on 26/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import MapKit
import BrightFutures
import Result

public class DataStore {
    
    var dataClient: DataClient
    
    public required init(dataClient: DataClient) {
        self.dataClient = dataClient
    }
    
    public func getNGOs(zipcode: String = "", searchText: String = "") -> Future<[NGO], DonandoError> {
        
        let promise = Promise<[NGO], DonandoError>()
        let futureResult = dataClient.getNGOs(zipcode, searchText: searchText)
        
        futureResult.onSuccess { result in
            guard let resultArray = result as? JSONArray else {
                promise.failure(DonandoError.GenericError)
                return
            }
            
            var ngos = [NGO]()
            for dict in resultArray {
                guard let dict = dict as? JSONDictionary,
                    ngoDict = dict["ngo"] as? JSONDictionary,
                    var ngo = NGO(dict: ngoDict)
                    where CLLocationCoordinate2DIsValid(ngo.coordinate)
                    else { continue }
                
                ngo.demands = dict["demands"] as? [String]
                ngos.append(ngo)
            }
            promise.success(ngos)
        }
        
        futureResult.onFailure { error in
            
        }
        
        return promise.future
    }
    
}
