//
//  Transaction.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import UIKit

class Transaction: NSObject {
    dynamic var recipient: String?
    dynamic var sendingCurrency: String?
    dynamic var receivingCurrency: String?
    dynamic var sendingAmount: NSNumber?
    dynamic var receivingAmount: NSNumber?
}
