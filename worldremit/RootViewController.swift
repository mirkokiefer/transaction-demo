//
//  RootViewController.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, SendViewControllerDelegate {
    
    let server = createServer()
    
    @IBAction func sendMoneyTapped(sender: AnyObject) {
        self.server.readCurrencies { (error, currencies) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.displaySendViewController(currencies!)
            })
        }
    }
    
    func displaySendViewController(currencies: [String]) {
        let naviController = self.storyboard!.instantiateViewControllerWithIdentifier("SendNaviViewController") as UINavigationController
        let sendController = naviController.topViewController as SendViewController
        let transaction = Transaction()
        transaction.sendingCurrency = currencies[0]
        transaction.receivingCurrency = currencies[1]
        sendController.transaction = transaction
        sendController.availableCurrencies = currencies
        sendController.server = self.server
        sendController.delegate = self
        self.presentViewController(naviController, animated: true, completion: nil)
    }
    
    @IBAction func didCancelSend(unwindSegue: UIStoryboardSegue) {
        
    }
    
    func sendViewControllerDidSendTransaction(controller: SendViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
