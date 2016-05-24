//
//  NGOAnnotation.swift
//  Donando
//
//  Created by Halil Gursoy on 26/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import MapKit
import BrightFutures

public class NGOAnnotation: NSObject, MKAnnotation {
    
    public static let reuseIdentifier = "NGOAnnotation"
    
    public let coordinate: CLLocationCoordinate2D
    public let name: String
    public let phoneNumber: String?
    public let address: String
    public let title: String?
    public let ngoIndex: Int
    
    required public init(ngo: NGO, index: Int = 0) {
        coordinate = ngo.coordinate
        name = ngo.name
        address = ngo.address
        phoneNumber = ngo.phoneNumber
        title = name
        ngoIndex = index
    }
}
