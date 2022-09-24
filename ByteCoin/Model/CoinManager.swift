//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateRate(rate: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "5958E7C1-7791-4390-B324-C78A973BD8C1"
    
    func getRate(currency: String, completion: @escaping (CoinData) -> Void){
        let json: [String: String] = [
            "X-CoinAPI-Key":apiKey
        ]
        
        guard let url = URL(string: baseURL + currency)
        else {
            print("url error")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = json
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let decoder = JSONDecoder()
            if let rateData = try? decoder.decode(CoinData.self, from: data) {
                print("data is safe")
                
                completion(rateData)
            }
        }
        task.resume()
    }
    
    func getRate(currency: String){
        let json: [String: String] = [
            "X-CoinAPI-Key":apiKey
        ]
        
        guard let url = URL(string: baseURL + currency)
        else {
            print("url error")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = json
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                delegate?.didFailWithError(error: error!)
                return
            }
            let decoder = JSONDecoder()
            if let rateData = try? decoder.decode(CoinData.self, from: data) {
                if let rate = rateData.rate {
                    let rateString = String(format: "%.1f", rate)
                    delegate?.didUpdateRate(rate: rateString)
                }
                
            }
        }
        task.resume()
    }
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

}
