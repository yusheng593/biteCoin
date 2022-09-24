//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        currencyLabel.text = currency
        coinManager.getRate(currency: currency)
        //use closure
//        coinManager.getRate(currency: currency) { coinData in
//            let rate = String(format: "%.1f", coinData.rate!)
//            DispatchQueue.main.async {
//                self.bitcoinLabel.text = rate
//            }
//
//        }
    }


}
//MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
}
//MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    func didUpdateRate(rate: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = rate
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
