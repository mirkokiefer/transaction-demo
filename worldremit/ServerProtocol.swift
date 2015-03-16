//
//  ServerProtocol.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import Foundation

typealias ReadCurrenciesHandler = (error: NSError?, currencies: [String]?) -> Void
typealias CalculateHandler = (error: NSError?, result: Double?) -> Void
typealias SendMoneyHandler = (error: NSError?) -> Void

protocol Server {
    func readCurrencies(handler: ReadCurrenciesHandler)
    func calculateReceiveAmount(sendAmount: Double, sendCurrency: String, receiveCurrency: String, handler: CalculateHandler)
    func sendMoney(transaction: Transaction, handler: SendMoneyHandler)
}
