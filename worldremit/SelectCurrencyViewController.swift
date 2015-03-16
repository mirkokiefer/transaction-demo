//
//  SelectCurrencyViewController.swift
//  worldremit
//
//  Created by Mirko on 3/16/15.
//  Copyright (c) 2015 LivelyCode. All rights reserved.
//

import UIKit

protocol SelectCurrencyViewControllerDelegate {
    func currencyViewController(controller: SelectCurrencyViewController, didSelectCurrency currency: String)
}

class SelectCurrencyViewController: UITableViewController {
    var currencies: [String]?
    var delegate: SelectCurrencyViewControllerDelegate?
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currencies!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        cell.textLabel?.text = self.currencies![indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currency = self.currencies![indexPath.row]
        self.delegate?.currencyViewController(self, didSelectCurrency: currency)
    }
}
