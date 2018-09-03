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
import LinkKit

enum ObjectType {
    case wallet, tag
}

class AddVC: UIViewController {
    
    //  MARK: - Outlets
    
    @IBOutlet weak var objectNameTextField: UITextField!
    @IBOutlet weak var alertView: UIView!
    
    // MARK: - Properties
    
    let stack = CoreDataStack.sharedInstance
    var objectName: String!
    var saveDelegate: SaveObjectDelegate?
    var objectToAdd: ObjectType?
    
    // MARK: - Override methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector: #selector(AddVC.didReceiveNotification(_:)), name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Plaid Link setup
        
        if let objectType = objectToAdd {
            
            var objectString = " "
            switch objectType {
            case .wallet:
                objectString = "wallet"
            case .tag:
                objectString = "tag"
            }

            objectNameTextField.placeholder = "Enter \(objectString) name here"
            
        }

        objectNameTextField.becomeFirstResponder()
        configureTextField(objectNameTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    @objc func didReceiveNotification(_ notification: NSNotification) {
        if notification.name.rawValue == "PLDPlaidLinkSetupFinished" {
            NotificationCenter.default.removeObserver(self, name: notification.name, object: nil)
            //button.isEnabled = true
        }
    }
    
    
    
    
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapPlaidLink(_ sender: Any) {
        presentPlaidLink()
    }
    @IBAction func create(_ sender: Any) {
        
        resignIfFirstResponder(objectNameTextField)
        
        if let objectType = objectToAdd {
            var object: NSManagedObject?
            switch objectType {
            case .wallet:
                object = Wallet(walletName: objectName, balance: 0.0, dateCreated: Date().simpleFormat as NSDate, context: self.stack.context)
            case .tag:
                object = Tag(name: objectName, context: self.stack.context)
            }
            guard let newObject = object else { return }
            saveDelegate?.saveObject(controller: self, saveObject: newObject, isNew: true) { (didSave) in
                if didSave {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
        
    }

    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.view.layoutIfNeeded()
        
//        let tapRecognizer = UIGestureRecognizer(target: self, action: #selector(self.dismiss(animated:completion:)))
//        tapRecognizer.delegate = self
//        self.view.addGestureRecognizer(tapRecognizer)
        
    }

    
//    func animateView() {
//        alertView.alpha = 0;
//        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
//        UIView.animate(withDuration: 0.4, animations: { () -> Void in
//            self.alertView.alpha = 1.0;
//            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
//        })
//    }
    
    // Plaid Link ViewController configuration methods
    
    func presentPlaidLink() {
        
        let linkViewDelegate = self
        let linkViewController = PLKPlaidLinkViewController(delegate: linkViewDelegate)
        present(linkViewController, animated: true, completion: nil)
    }
    
    // AlertView configuration methods
    
    func handleSuccessWithToken(_ publicToken: String, metadata: [String : Any]?) {
        
        let path = "/item/public_token/exchange"
        
        PlaidClient.sharedInstance.makeRequest(withPath: path, publicToken: publicToken) { (result, error, errorString) in
            
            if error != nil {
                print(errorString)
            } else {
                print("RESULT: \(result)")
            }
            
            
        }
        presentAlertViewWithTitle("Success", message: "token: \(publicToken)\nmetadata: \(metadata ?? [:])")
    }
    
    func handleError(_ error: Error, metadata: [String : Any]?) {
        presentAlertViewWithTitle("Failure", message: "error: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
    }
    
    func handleExitWithMetadata(_ metadata: [String : Any]?) {
        presentAlertViewWithTitle("Exit", message: "metadata: \(metadata ?? [:])")
    }
    
    func presentAlertViewWithTitle(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension AddVC : UITextFieldDelegate {
    
    // TextFielDelegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == objectNameTextField {
            
            guard let name = objectNameTextField.text as? String else {
                print("Wallet name not entered")
                return
            }
            
            objectName = name
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
    
}

extension AddVC : PLKPlaidLinkViewDelegate {
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didSucceedWithPublicToken publicToken: String, metadata: [String : Any]?) {
        dismiss(animated: true) {
            // Handle success, e.g. by storing publicToken with your service
            NSLog("Successfully linked account!\npublicToken: \(publicToken)\nmetadata: \(metadata ?? [:])")
            self.handleSuccessWithToken(publicToken, metadata: metadata)
            linkViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func linkViewController(_ linkViewController: PLKPlaidLinkViewController, didExitWithError error: Error?, metadata: [String : Any]?) {
        dismiss(animated: true) {
            if let error = error {
                NSLog("Failed to link account due to: \(error.localizedDescription)\nmetadata: \(metadata ?? [:])")
                self.handleError(error, metadata: metadata)
            }
            else {
                NSLog("Plaid link exited with metadata: \(metadata ?? [:])")
                self.handleExitWithMetadata(metadata)
            }
        }
    }
    
}
