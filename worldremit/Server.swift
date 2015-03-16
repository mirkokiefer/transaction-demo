//
//  Server.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import UIKit

typealias ReadCurrenciesHandler = (error: NSError?, currencies: [String]) -> Void
typealias CalculateHandler = (error: NSError?, result: Double) -> Void
typealias SendMoneyHandler = (error: NSError?) -> Void

class Server: NSObject {
   
    func readCurrencies(handler: ReadCurrenciesHandler) {
        let currencies = ["GBP", "USD", "PHP", "EUR"]
        handler(error: nil, currencies: currencies)
    }
    
    func calculateReceiveAmount(sendAmount: Double, sendCurrency: String, receiveCurrency: String, handler: CalculateHandler) {
        let result = sendAmount * 2
        handler(error: nil, result: result)
    }
    
    func sendMoney(transaction: Transaction, handler: SendMoneyHandler) {
        handler(error: nil)
    }
}
