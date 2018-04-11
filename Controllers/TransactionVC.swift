 //
//  AddTransactionViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/11/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

class TransactionVC: UIViewController {
    
    var transaction: Transaction?
    var itemIndex: IndexPath?
    var isIncome: Bool?
    weak var walletVC: WalletVC?  //https://stackoverflow.com/questions/32028405/presentingviewcontroller-returns-the-parent-of-the-actual-presenting-view-contro
    var isLaterDate: Bool = false
    let stack = CoreDataStack.sharedInstance
    var transactionTitle: String?
    var transactionDate: Date?
    var amount: Double?
    var oldTransaction : TransactionStruct?
    var newTransaction : TransactionStruct?
    var saveDelegate: UpdateModelDelegate?
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
            transactionDate = transaction.createdAt as? Date
            amount = transaction.amount
            isIncome = transaction.income
            
            oldTransaction = TransactionStruct(description: transaction.title!, amount: transaction.amount, date: transaction.createdAt! as Date, income: transaction.income)
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
        print("walletVC transVC : \(walletVC)")
    }

    @IBAction func cancelPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        
        resignIfFirstResponder(amountTextField)
        resignIfFirstResponder(descriptionTextField)
        
        isIncome = incomeSwitch.isOn
        let multiplier = -1.0
        
        if (amount! < 0.0 && isIncome!) || (amount! > 0.0 && !isIncome!) {
            amount = amount! * multiplier
        }
        
        if updatedValue {
            
            newTransaction = TransactionStruct(description: transactionTitle!, amount: amount!, date: transactionDate!, income: isIncome!)
            
            transaction!.createdAt = transactionDate as! NSDate
            transaction!.amount = amount!
            transaction!.title = transactionTitle
            transaction!.income = isIncome!
            
            if isLaterDate {
                walletVC?.getNextTransaction(fromTransaction: transaction!) { (result) in
                    self.saveDelegate?.updateModel(controller: self, saveObject: result!, isNew: false)
                }
            } else {
                saveDelegate?.updateModel(controller: self, saveObject: transaction!, isNew: false)
            }

        } else {
            
            let new = Transaction(title: descriptionTextField.text!, amount: amount!, income: isIncome!, createdAt: transactionDate! as NSDate , context: stack.context)
            saveDelegate?.updateModel(controller: self, saveObject: new, isNew: true)
            
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // Transaction date was changed to a later date
        if oldTransaction?.date.compare(sender.date) == ComparisonResult.orderedAscending {
            isLaterDate = true
        }
        
        transactionDate = sender.date
        
        if let transaction = transaction {
            if transactionDate != (transaction.createdAt as Date?) {
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
                saveButton.isEnabled = ((transaction.createdAt! as Date) != transactionDate) || (transaction.title != transactionTitle) || (transaction.amount != amount)
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
        
        if transaction != nil {
            
            datePicker.date = transactionDate!
            descriptionTextField.text = transactionTitle
            amountTextField.text = "\(amount!)"
            incomeSwitch.isOn = isIncome!
            
        } else {
            
            transactionDate = Date()
            datePicker.date = transactionDate!
            incomeSwitch.isOn = false
        }
        
    }
    
    func configureTextField(_ textField: UITextField) {
        
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        
    }
}

extension TransactionVC : UITextFieldDelegate {
    
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
                saveButton.isEnabled = ((transaction.createdAt! as Date) != transactionDate) || (transaction.income != isIncome)
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
