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
    var isIncome: Bool! = false
    let stack = CoreDataStack.sharedInstance
    var transactionDate: NSDate?
    var amount: Double?
    var delegate: UpdateModelDelegate?
    var isNewTransaction: Bool?
    var updatedValue: Bool?
    
    

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var incomeSwitch: UISwitch! {
        
        didSet {
            isIncome = incomeSwitch.isOn ? true : false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTextField(descriptionTextField)
        configureTextField(amountTextField)
        
        setUpView()
    
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
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
        
        if isNewTransaction! {
            
            let newTransaction = Transaction(title: descriptionTextField.text!, amount: amount!, income: isIncome, createdAt: transactionDate! , context: stack.context)
            delegate?.updateModel(controller: self, saveObject: newTransaction, isNew: true, indexPath: nil)
            
            
        } else {
            
            transaction?.createdAt = transactionDate
            transaction?.amount = amount!
            transaction?.title = descriptionTextField.text
            transaction?.income = isIncome
            delegate?.updateModel(controller: self, saveObject: transaction!, isNew: false, indexPath: itemIndex)
            
        }
        
        let parentVC = self.parent as? WalletViewController
        parentVC?.transactionTableView.dataSource = parentVC
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        transactionDate = sender.date as NSDate
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(descriptionTextField)
        resignIfFirstResponder(amountTextField)
    }
    
    func setUpView() {
        
        if isNewTransaction! {
            transactionDate = NSDate()
            datePicker.date = transactionDate as! Date
        } else {
            transactionDate = transaction!.createdAt
            datePicker.date = transactionDate as! Date
            descriptionTextField.text = transaction!.title
            amount = transaction!.amount
            amountTextField.text = "\(amount!)"
            isIncome = transaction!.income
        }
        
    }
    
    func configureTextField(_ textField: UITextField) {
        
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        
    }
    
    
}

 extension TransactionViewController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == amountTextField {
//            let numberFormatter = NumberFormatter()
//            numberFormatter.numberStyle = .decimal
            amount = (amountTextField.text! as NSString).doubleValue
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
