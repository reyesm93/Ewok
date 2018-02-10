//
//  AddViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/1/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

//protocol AddViewControllerDelegate: class {
//    func createObject(_ object: NSManagedObject)
//}

protocol AddViewControllerDelegate: class {
    func sendProperties(name : String, balance: Float)
}

class AddViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var walletNameTF: UITextField!
    @IBOutlet weak var balanceTF: UITextField!
    @IBOutlet weak var alertView: UIView!
    let stack = CoreDataStack.sharedInstance
    var walletName: String!
    var balance: Float!
    var wallet : Wallet!
    var delegate: AddViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        walletNameTF.becomeFirstResponder()
        
        configureTextField(walletNameTF)
        configureTextField(balanceTF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func create(_ sender: Any) {
        
        if balanceTF.text == "" {
            self.balance = 0.0
        }
        
//        wallet = Wallet(walletName: walletName, balance: balance, createdAt: NSDate(), context: self.stack.context)
        
        delegate?.sendProperties(name: walletName, balance: balance)
        
        self.dismiss(animated: true, completion: nil)
    }

    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.layoutIfNeeded()
        
//        let tapRecognizer = UIGestureRecognizer(target: self, action: #selector(self.dismiss(animated:completion:)))
//        tapRecognizer.delegate = self
//        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    // TextFielDelegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == walletNameTF {
           
            guard let name = walletNameTF.text as? String else {
                print("Wallet name not entered")
                return
            }
            
            walletName = name
        } else if textField == balanceTF {
            
            if let number = Float(balanceTF.text!){
                self.balance = number
            } else {
                self.balance = 0.0
            }
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
    
    func configureTextField(_ textField: UITextField) {
        
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        
    }
    
//    func animateView() {
//        alertView.alpha = 0;
//        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
//        UIView.animate(withDuration: 0.4, animations: { () -> Void in
//            self.alertView.alpha = 1.0;
//            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
//        })
//    }
    
    
    
}
