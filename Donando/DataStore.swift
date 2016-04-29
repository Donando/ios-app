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
    
    public func getAllNGOs(zipcode: String = "", searchText: String = "") -> Future<[NGO], DonandoError> {
        
        let promise = Promise<[NGO], DonandoError>()
//        let futureResult = dataClient.getNGOs(zipcode, searchText: searchText)
        
        var ngos = [NGO]()
        
//        futureResult.onSuccess { result in
//            guard let resultArray = result as? JSONArray else {
//                promise.failure(DonandoError.GenericError)
//                return
//            }
//            
//            for dict in resultArray {
//                guard let dict = dict as? JSONDictionary,
//                    ngo = NGO(dict: dict) else { continue }
//                ngos.append(ngo)
//            }
//            
//            promise.success(ngos)
//        }
        let ngo1 = NGO(name: "Notunterkunft", phoneNumber: "03076809417", address: "Großbeerenstraße 34, 12107 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.4362033, longitude: 13.3766713), openingHours: "10:00 Uhr - 18:00 Uhr")
        let ngo2 = NGO(name: "Hotel 54", phoneNumber: "030200736430", address: "Chauseestr. 54, 10115 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.5358921, longitude: 13.374632))
        let ngo3 = NGO(name: "Medizin hilft Flüchtlingen", phoneNumber: "015175488806", address: "Flüchtlingsunterkunft Wilmersdorf, 10713 Berlin", coordinate: CLLocationCoordinate2D(latitude: 52.5158746, longitude: 13.2999146), websiteURL: "http://www.google.com")
        
        ngos.append(ngo1)
        ngos.append(ngo2)
        ngos.append(ngo3)
        
        promise.success(ngos)
        
        return promise.future
    }
    
}