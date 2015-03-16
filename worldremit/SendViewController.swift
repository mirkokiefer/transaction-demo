//
//  ViewController.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import UIKit
import BlocksKit
import AddressBookUI

enum CurrencyType {
    case Sending
    case Receiving
}

protocol SendViewControllerDelegate {
    func sendViewControllerDidSendTransaction(controller: SendViewController)
}

class SendViewController: UIViewController, SelectCurrencyViewControllerDelegate, UIAlertViewDelegate, ABPeoplePickerNavigationControllerDelegate {

    var availableCurrencies: [String]!
    var transaction: Transaction!
    var selectingCurrency: CurrencyType!
    var server: Server!
    var delegate: SendViewControllerDelegate!
    
    var transactionSuccessAlert: UIAlertView?
    @IBOutlet weak var recipientField: UITextField!
    @IBOutlet weak var sendingCurrencyLabel: UILabel!
    @IBOutlet weak var receivingCurrencyLabel: UILabel!
    @IBOutlet weak var sendingAmountField: UITextField!
    @IBOutlet weak var receivingAmountField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerEvents()
        self.sendingAmountField!.inputAccessoryView = self.createSendAmountFieldToolbar()
    }
    
    func registerEvents() {
        self.transaction.bk_addObserverForKeyPath("sendingCurrency", task: { (sender) -> Void in
            self.sendingCurrencyLabel.text = self.transaction.sendingCurrency
        })
        self.transaction.bk_addObserverForKeyPath("receivingCurrency", task: { (sender) -> Void in
            self.receivingCurrencyLabel.text = self.transaction.receivingCurrency
        })
        self.transaction.bk_addObserverForKeyPath("sendingAmount", task: { (sender) -> Void in
            self.updateReceivingAmount()
        })
        self.transaction.bk_addObserverForKeyPath("receivingAmount", task: { (sender) -> Void in
            self.receivingAmountField.text = self.transaction.receivingAmount!.stringValue
        })
        self.transaction.bk_addObserverForKeyPath("recipient", task: { (sender) -> Void in
            self.recipientField.text = self.transaction.recipient
        })
    }
    
    func displayPeoplePicker() {
        let peoplePicker = ABPeoplePickerNavigationController()
        peoplePicker.peoplePickerDelegate = self
        self.presentViewController(peoplePicker, animated: true, completion: nil)
    }
    
    func peoplePickerNavigationController(peoplePicker: ABPeoplePickerNavigationController!, didSelectPerson person: ABRecord!) {
        let name = ABRecordCopyCompositeName(person).takeRetainedValue() as String
        self.transaction.recipient = name
    }
    
    func updateReceivingAmount() {
        let transaction = self.transaction!
        if transaction.sendingAmount == nil {
            transaction.receivingAmount = 0
            return
        }
        let sendingAmount = transaction.sendingAmount!.doubleValue
        let sendingCurrency = transaction.sendingCurrency!
        let receivingCurrency = transaction.receivingCurrency!
        self.server.calculateReceiveAmount(sendingAmount, sendCurrency: sendingCurrency, receiveCurrency: receivingCurrency) { (error, result) -> Void in
            transaction.receivingAmount = result
        }
    }
    
    func createSendAmountFieldToolbar() -> UIToolbar {
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        let space = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "sendingAmountDoneTapped:")
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
    
    func sendingAmountDoneTapped(sender: AnyObject) {
        self.sendingAmountField.resignFirstResponder()
    }
    
    @IBAction func sendMoney(sender: AnyObject) {
        let recipient = self.transaction.recipient
        if (recipient == nil) {
            let alert = UIAlertView(title: "Missing Recipient", message: "Choose a recipient for your transaction.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Continue")
            alert.show()
            return
        }
        let amount = self.transaction.receivingAmount
        if (amount == nil) {
            let alert = UIAlertView(title: "Missing Amount", message: "Choose the amount you want to send.", delegate: nil, cancelButtonTitle: nil, otherButtonTitles: "Continue")
            alert.show()
            return
        }
        let currency = self.transaction.receivingCurrency!
        
        self.activityIndicator.startAnimating()
        self.server.sendMoney(self.transaction, handler: { (error) -> Void in
            let message = "\(currency) \(amount!) will be transferred to \(recipient!)."
            let alert = UIAlertView(title: "Transaction successful", message: message, delegate: self, cancelButtonTitle: nil, otherButtonTitles: "Continue")
            alert.show()
            self.transactionSuccessAlert = alert
        })
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
            self.transaction.sendingCurrency = currency
        case .Receiving:
            self.transaction.receivingCurrency = currency
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (alertView == self.transactionSuccessAlert) {
            self.delegate.sendViewControllerDidSendTransaction(self)
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        self.displayPeoplePicker()
        return false
    }
}

