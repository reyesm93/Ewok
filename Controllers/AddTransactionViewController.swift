 //
//  AddTransactionViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/11/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

class AddTransactionViewController: UIViewController, UITextFieldDelegate {
    
    var isIncome: Bool! = false
    let stack = CoreDataStack.sharedInstance
    var transactionDate: NSDate?
    var amount: Float?
    var wallet: Wallet!
    

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
        
        transactionDate = NSDate()
        
        descriptionTextField.delegate = self
        amountTextField.delegate = self
        descriptionTextField.returnKeyType = UIReturnKeyType.done
        amountTextField.returnKeyType = UIReturnKeyType.done
    
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    

    }

    
    @IBAction func addTransaction(_ sender: Any) {
        
        stack.context.performAndWait {
            let transaction = Transaction(title: descriptionTextField.text!, amount: amount!, income: isIncome, createdAt: transactionDate! , context: stack.context)
            transaction.wallet = wallet
            stack.save()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        transactionDate = sender.date as NSDate
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(descriptionTextField)
        resignIfFirstResponder(amountTextField)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == amountTextField {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            amount = (amountTextField.text! as NSString).floatValue
            
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

