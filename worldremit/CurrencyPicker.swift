//
//  CurrencyPicker.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import UIKit

class CurrencyPicker: UIView {
    var label: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.redColor()
        let label = UILabel()
        label.text = "EUR"
        self.label = label
        self.addSubview(label)
    }
}
