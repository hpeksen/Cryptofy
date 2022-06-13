//
//  JsonObject.swift
//  Cryptofy
//
//  Created by Hakan Pekşen on 10.06.2022.
//

import Foundation

struct JsonObject: Decodable{
    let id: String?
    let name: String?
    let symbol: String?
    let logo_url: String?
    let price: String?
}
