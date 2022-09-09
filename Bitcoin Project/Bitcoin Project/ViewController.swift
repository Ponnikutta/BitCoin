//
//  ViewController.swift
//  Bitcoin Project
//
//  Created by Vivek Lakshmanan on 19/05/22.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManager = CoinManager()
    var selectedCurrency: String?
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // this will say the number of columns
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count // this will say the number of rows
    }
    
}

//MARK: - UIPickerView Delegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        coinManager.currencyArray[row] // this will get called everytime and the row name get updated based on array
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(coinManager.currencyArray[row]) //This will get called every time when the user scrolls the picker, When that happens it will record the row number that was selected.
        selectedCurrency = coinManager.currencyArray[row]
        
        coinManager.getCoinPrice(for: selectedCurrency!)
    }
    
}

//MARK: - Bitcoin Delegate

extension ViewController: bitcoinDelegate {
    
    func didUpdaterate(_ coinManager: CoinManager, bitcoinRate: Double) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.2f", bitcoinRate)
            self.currencyLabel.text = self.selectedCurrency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
