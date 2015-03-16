//
//  ViewController.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import UIKit
import BlocksKit

enum CurrencyType {
    case Sending
    case Receiving
}

class ViewController: UIViewController, SelectCurrencyViewControllerDelegate {

    var availableCurrencies = ["GBP", "USD", "PHP", "EUR"]
    var transaction: Transaction?
    var selectingCurrency: CurrencyType?
    
    @IBOutlet weak var receipientLabel: UILabel!
    @IBOutlet weak var sendingCurrencyLabel: UILabel!
    @IBOutlet weak var receivingCurrencyLabel: UILabel!
    @IBOutlet weak var sendingAmountField: UITextField!
    @IBOutlet weak var receivingAmountField: UITextField!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.transaction = Transaction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerEvents()
        self.transaction!.sendingCurrency = self.availableCurrencies[0]
        self.transaction!.receivingCurrency = self.availableCurrencies[1]
        
        self.sendingAmountField!.inputAccessoryView = self.createSendAmountFieldToolbar()
        self.sendingAmountField.becomeFirstResponder()
    }
    
    func registerEvents() {
        self.transaction!.bk_addObserverForKeyPath("sendingCurrency", task: { (sender) -> Void in
            self.sendingCurrencyLabel.text = self.transaction!.sendingCurrency
        })
        self.transaction!.bk_addObserverForKeyPath("receivingCurrency", task: { (sender) -> Void in
            self.receivingCurrencyLabel.text = self.transaction!.receivingCurrency
        })
        self.transaction!.bk_addObserverForKeyPath("sendingAmount", task: { (sender) -> Void in
            self.updateReceivingAmount()
        })
        self.transaction!.bk_addObserverForKeyPath("receivingAmount", task: { (sender) -> Void in
            self.receivingAmountField.text = self.transaction!.receivingAmount!.stringValue
        })
    }
    
    func updateReceivingAmount() {
        if self.transaction!.sendingAmount == nil {
            self.transaction!.receivingAmount = 0
            return
        }
        self.transaction!.receivingAmount = self.transaction!.sendingAmount!.doubleValue * 2
    }
    
    func createSendAmountFieldToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "doneTapped:")
        toolbar.items = [space, doneButton]
        return toolbar
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "selectSendingCurrency") {
            let naviController = segue.destinationViewController as UINavigationController
            let currencyController = naviController.topViewController as SelectCurrencyViewController
            currencyController.currencies = self.availableCurrencies
            currencyController.delegate = self
            self.selectingCurrency = .Sending
        }
        if (segue.identifier == "selectReceivingCurrency") {
            let naviController = segue.destinationViewController as UINavigationController
            let currencyController = naviController.topViewController as SelectCurrencyViewController
            currencyController.currencies = self.availableCurrencies
            currencyController.delegate = self
            self.selectingCurrency = .Receiving
        }
    }
    
    @IBAction func sendMoney(sender: AnyObject) {
        
    }
    
    @IBAction func didChangeSendingAmount(sender: AnyObject) {
        let sendingAmountString = self.sendingAmountField!.text
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .DecimalStyle
        let amount = formatter.numberFromString(sendingAmountString)
        self.transaction!.sendingAmount = amount
    }
    
    @IBAction func didCancelSelectCurrency(unwindSegue: UIStoryboardSegue) {
        
    }
    
    func currencyViewController(controller: SelectCurrencyViewController, didSelectCurrency currency: String) {
        switch (self.selectingCurrency!) {
        case .Sending:
            self.transaction!.sendingCurrency = currency
        case .Receiving:
            self.transaction!.receivingCurrency = currency
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

