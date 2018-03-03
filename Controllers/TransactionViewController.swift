 //
//  AddTransactionViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/11/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

class TransactionViewController: UIViewController {
    
    var transaction: Transaction?
    var itemIndex: IndexPath?
    var isIncome: Bool?
    let stack = CoreDataStack.sharedInstance
    var transactionTitle: String?
    var transactionDate: NSDate?
    var amount: Double?
    var delegate: UpdateModelDelegate?
    var newValues = [String : Any]()
    var updatedValue = false {
        didSet {
            if updatedValue {
                self.saveButton.isEnabled = true
            }
        }
    }
    

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var incomeSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let transaction = transaction {
            transactionTitle = transaction.title
            transactionDate = transaction.createdAt
            amount = transaction.amount
            isIncome = transaction.income
        }
        
        saveButton.isEnabled = false
        
        configureTextField(descriptionTextField)
        configureTextField(amountTextField)
        
        setUpView()
    
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        incomeSwitch.addTarget(self, action: #selector(switchValueChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    @IBAction func cancelPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        resignIfFirstResponder(amountTextField)
        resignIfFirstResponder(descriptionTextField)
        
        newValues["title"] = transactionTitle
        newValues["amount"] = amount!
        newValues["createdAt"] = transactionDate
        
        if updatedValue {
            
            transaction!.createdAt = newValues["createdAt"] as? NSDate
            transaction!.amount = newValues["amount"] as! Double
            transaction!.title = newValues["title"] as? String
            transaction!.income = isIncome!
            delegate?.updateModel(controller: self, saveObject: transaction!, isNew: false, indexPath: itemIndex)
            
        } else {
            
            let newTransaction = Transaction(title: descriptionTextField.text!, amount: amount!, income: isIncome!, createdAt: transactionDate! , context: stack.context)
            delegate?.updateModel(controller: self, saveObject: newTransaction, isNew: true, indexPath: nil)
            
        }
        
        let parentVC = self.parent as? WalletViewController
        parentVC?.transactionTableView.dataSource = parentVC
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        transactionDate = sender.date as NSDate
        
        if let transaction = transaction {
            if transactionDate != transaction.createdAt {
            updatedValue = true
            }
        }
    }
    
    @objc func switchValueChanged(_sender: UISwitch) {
        
        isIncome = incomeSwitch.isOn
        
        if let transaction = transaction {
            if isIncome != transaction.income {
                updatedValue = true
            } else {
                saveButton.isEnabled = (transaction.createdAt != transactionDate) || (transaction.title != transactionTitle) || (transaction.amount != amount)
            }
        } else {
            saveButton.isEnabled = (amount != nil) && (transactionTitle != nil)
        }
        
    }

    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(descriptionTextField)
        resignIfFirstResponder(amountTextField)
    }
    
    func setUpView() {
        
        if let transaction = transaction {
            
            datePicker.date = transactionDate as! Date
            descriptionTextField.text = transaction.title
            amountTextField.text = "\(amount!)"
            
        } else {
            transactionDate = NSDate()
            datePicker.date = transactionDate as! Date
            incomeSwitch.isOn = false
        }
        
    }
    
    func configureTextField(_ textField: UITextField) {
        
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        
    }
}

extension TransactionViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField {
        case amountTextField:
            amount = (amountTextField.text! as NSString).doubleValue
        case descriptionTextField:
            transactionTitle = descriptionTextField.text!
        default:
            break
        }
        
        if let transaction = transaction {
            if (amount != transaction.amount) || (transactionTitle != transaction.title) {
                updatedValue = true
            } else {
                saveButton.isEnabled = (transaction.createdAt != transactionDate) || (transaction.income != isIncome)
            }
        } else {
            saveButton.isEnabled = (amount != nil) && (transactionTitle != nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }

}
