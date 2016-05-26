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
            address = dict["address"] as? String
            else { return nil }
        
        let url = dict["url"] as? String
        let phoneNumber = dict["phone"] as? String
        
        let latitude = dict["latitude"] as? CLLocationDegrees ?? 0
        let longitude = dict["longitude"] as? CLLocationDegrees ?? 0
        
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        self.init(ngoId: id, name: name, phoneNumber: phoneNumber, address: address, openingHours: "10.00 Uhr - 18.30 Uhr", websiteURL: url, coordinate: coordinates)
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