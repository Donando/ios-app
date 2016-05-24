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
            var coordinatesFetched = [Bool]()
            
            for (index, dict) in resultArray.enumerate() {
                guard let dict = dict as? JSONDictionary,
                    ngoDict = dict["ngo"] as? JSONDictionary,
                    var ngo = NGO(dict: ngoDict)
                    else { continue }
                
                coordinatesFetched.append(false)
                ngo.demands = dict["demands"] as? [String]
                
                
                let coordinateFuture = ngo.findCoordinates()
                coordinateFuture.onComplete { result in
                    if let coordinates = result.value {
                        ngo.coordinate = coordinates
                    }
                    
                    ngos.append(ngo)
                    
                    coordinatesFetched[index] = true
                    if coordinatesFetched.reduce(true, combine: { fetched, thisFetched in return fetched && thisFetched}) {
                        promise.success(ngos)
                    }
                }
            }
        }
        
        futureResult.onFailure { error in
            
        }
//        let ngo1 = NGO(name: "Notunterkunft", phoneNumber: "03076809417", address: "Großbeerenstraße 34, 12107 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.4362033, longitude: 13.3766713), openingHours: "10:00 Uhr - 18:00 Uhr")
//        let ngo2 = NGO(name: "Hotel 54", phoneNumber: "030200736430", address: "Chauseestr. 54, 10115 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.5358921, longitude: 13.374632))
//        let ngo3 = NGO(name: "Medizin hilft Flüchtlingen", phoneNumber: "015175488806", address: "Flüchtlingsunterkunft Wilmersdorf, 10713 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.5158746, longitude: 13.2999146), websiteURL: "http://www.google.com")
//        
//        ngos.append(ngo1)
//        ngos.append(ngo2)
//        ngos.append(ngo3)
        
//        promise.success(ngos)
        
        return promise.future
    }
    
}