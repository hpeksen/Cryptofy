//
//  CryptoListViewModel.swift
//  Cryptofy
//
//  Created by Hakan Pekşen on 15.06.2022.
//

import Foundation

//CryptoListViewModel class and related methods
struct CryptoListViewModel {
    let cryptoCurrencyList: [CryptoDataModel]
    
    func numberOfRowsInSection() -> Int? {
        return self.cryptoCurrencyList.count 
     }
    func getAllData() -> [CryptoDataModel] {
         return cryptoCurrencyList
     }
     func cryptoAtIndex(_ index: Int) -> CryptoViewModel {
         let crypto = self.cryptoCurrencyList[index]
         return CryptoViewModel(crypto)
     }
}

struct CryptoViewModel {
    let crytpoCurrency: CryptoDataModel
    
    init(_ crypto: CryptoDataModel) {
        self.crytpoCurrency = crypto
    }
    var id: String {
        return self.crytpoCurrency.id
    }
    var name: String {
        return self.crytpoCurrency.name
    }
    var symbol: String {
        return self.crytpoCurrency.symbol
    }
    var image: String {
        return self.crytpoCurrency.image
    }
    var price: Double {
        return self.crytpoCurrency.current_price
    }
}


