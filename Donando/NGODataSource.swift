//
//  NGODataSource.swift
//  Donando
//
//  Created by Halil Gursoy on 16/06/16.
//  Copyright © 2016 Donando. All rights reserved.
//

import Foundation
import BrightFutures

protocol NgoDataSourceConsumer {
    func handle(ngos: [NGO])
    func handle(error: DonandoError)
}

extension NgoDataSourceConsumer {
    func handle(error: DonandoError) {
        //Optional method
    }
}

class NgoDataSource {
    private var dataSourceConsumers = [NgoDataSourceConsumer]()
    private let dataStore: DataStore
    
    required init(_ dataStore: DataStore = DataStore(dataClient: APIClient())) {
        self.dataStore = dataStore
    }
    
    func add(dataSourceUser: NgoDataSourceConsumer) {
        dataSourceConsumers.append(dataSourceUser)
    }
    
    func loadData(searchText: String = "", zipcode: String = "") {
        
        let ngoFuture = dataStore.getNGOs(zipcode, searchText: searchText)
        ngoFuture.onSuccess(callback: handle)
        ngoFuture.onFailure(callback: handle)
    }
    
    func handle(ngos: [NGO]) {
        for dataSourceConsumer in dataSourceConsumers {
            dataSourceConsumer.handle(ngos)
        }
    }
    
    func handle(error: DonandoError) {
        for dataSourceConsumer in dataSourceConsumers {
            dataSourceConsumer.handle(error)
        }
    }
}


