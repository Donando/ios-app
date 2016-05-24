//
//  NGO.swift
//  Donando
//
//  Created by Halil Gursoy on 23/05/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import MapKit
import BrightFutures
import Result

public struct NGO {
    let ngoId: Int
    let name: String
    let address: String
    var coordinate =  CLLocationCoordinate2D()
    let openingHours: String?
    let websiteURL: String?
    let phoneNumber: String?
    let email: String?
    var demands: [String]?
    
    public init(ngoId: Int = 0, name: String, phoneNumber: String? = nil, email: String? = nil, address: String, coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(), openingHours: String? = nil, websiteURL: String? = nil, demands: [String]? = nil) {
        self.ngoId = ngoId
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.coordinate = coordinate
        self.openingHours = openingHours
        self.websiteURL = websiteURL
        self.demands = demands
        self.email = email
    }
    
    public func findCoordinates() -> Future<CLLocationCoordinate2D, DonandoError> {
        let promise = Promise<CLLocationCoordinate2D, DonandoError>()
        
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            guard let placemark = placemarks?.first,
                    coordinates = placemark.location?.coordinate
                else {
                    promise.failure(DonandoError.GenericError)
                    return
            }
            
            promise.success(coordinates)
        })
        
        return promise.future
    }
}