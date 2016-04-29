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

public struct NGO {
    let ngoId: Int
    let name: String
    let phoneNumber: String
    let address: String
    var coordinate =  CLLocationCoordinate2D()
    let openingHours: String?
    let demandText: String?
    let websiteURL: String?
    
    init(ngoId: Int = 0, name: String, phoneNumber: String, address: String, coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(), openingHours: String? = nil, demandText: String? = "", websiteURL: String? = nil) {
        self.ngoId = ngoId
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.coordinate = coordinate
        self.openingHours = openingHours
        self.demandText = demandText
        self.websiteURL = websiteURL
    }
    
}

public class NGOAnnotation: NSObject, MKAnnotation {
    
    public static let reuseIdentifier = "NGOAnnotation"
    
    public let coordinate: CLLocationCoordinate2D
    public let name: String
    public let phoneNumber: String
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
