//
//  WebService.swift
//  Cryptofy
//
//  Created by Hakan Pekşen on 15.06.2022.
//

import Foundation

//Download data
class WebService {
    func downloadCurrencies(url: URL, completion: @escaping ([CryptoDataModel]?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
            } else if let data = data {
                
                let crytpoList = try? JSONDecoder().decode([CryptoDataModel].self, from: data)
                print(crytpoList ?? "")
                
                if crytpoList != nil {
                    completion(crytpoList)
                }
            }
        }.resume()
    }
}
