//
//  ModelFactory.swift
//  Donando
//
//  Created by Halil Gursoy on 29/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import MapKit
import BrightFutures


public typealias JSONDictionary = [String: AnyObject]
public typealias JSONArray = [AnyObject]
public typealias JSONNumber = Double
public typealias JSONString = String

/**
 
 Implement this protocol to allow a object to be initiated with a JSONDictionary instance
 
 */
public protocol JSONDictInitable {
    init?(dict: JSONDictionary)
}


/**
 
 Implement this protocol to allow a object to be converted into it's JSONDictionary format.
 
 */

public protocol JSONDictConvertable {
    func asDictionary() -> JSONDictionary
}


extension NGO: JSONDictInitable {
    public init?(dict: JSONDictionary) {
        guard let id = dict["id"] as? Int,
            name = dict["name"] as? String,
            address = dict["address"] as? String,
            phone = dict["phone"] as? String else { return nil }
        
        self.init(ngoId: id, name: name, phoneNumber: phone, address: address, openingHours: "10.00 Uhr - 18.30 Uhr", demandText: "type: shoe -  kinder - size : 43 - gender : male  ", websiteURL: "http://wwww.google.com")
    }
}


extension String {
    public func findCoordinates() -> Future<CLLocationCoordinate2D, DonandoError> {
        let promise = Promise<CLLocationCoordinate2D, DonandoError>()
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(self) { (placemarks, error) in
            if let placemarkCoordinate = placemarks?.first?.location?.coordinate {
                promise.success(placemarkCoordinate)
            } else {
                promise.failure(DonandoError.GenericError)
            }
        }
        return promise.future
    }
}