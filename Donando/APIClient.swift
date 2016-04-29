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
        let request = webClient.createRequest(API: APIName.NGOs, endpointPath: Endpoints.ngoNear, ids: [Endpoints.zipCodeToken: zipCode, Endpoints.searchTextToken: searchText])
        return webClient.sendRequest(request)
    }
    
}