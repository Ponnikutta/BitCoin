
protocol bitcoinDelegate {
    func didUpdaterate(_ coinManager: CoinManager, bitcoinRate: Double)
    func didFailWithError(error: Error)
    
}

import Foundation

struct CoinManager {
    
    var delegate: bitcoinDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "A6B76E41-0C97-4CF2-BDE6-EBA170DB28FE"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        
        let fullurl = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: fullurl) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let rate = parseJSON(safeData) {
                        delegate?.didUpdaterate(self, bitcoinRate: rate)
                    }
                }
            }
            
            task.resume()
        }
    
    }
    
    func parseJSON(_ bitcoinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(Coinparse.self, from: bitcoinData)
            let bitcoinRate = decodedData.rate
//            print(bitcoinRate)
            return bitcoinRate
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
