//
//  DataClient.swift
//  Donando
//
//  Created by Halil Gursoy on 29/04/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import BrightFutures

public typealias DataResult = Future<AnyObject?, DonandoError>

public protocol DataClient {
    
    func getNGOs(zipCode: String, searchText: String) -> DataResult
}
