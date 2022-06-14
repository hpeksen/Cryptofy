//
//  JsonObject.swift
//  Cryptofy
//
//  Created by Hakan Pekşen on 10.06.2022.
//

import Foundation
//Crypto Data Model class
struct CryptoDataModel: Decodable{
    let id: String
    let name: String
    let symbol: String
    let image: String
    let current_price: Double
}
