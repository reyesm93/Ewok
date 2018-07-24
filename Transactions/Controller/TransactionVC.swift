 //
//  AddTransactionViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/11/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TransactionVC: UIViewController {
    
    // MARK: Properties
    
    var transaction: Transaction?
    var itemIndex: IndexPath?
    var isIncome: Bool?
    weak var walletVC: WalletVC?  //https://stackoverflow.com/questions/32028405/presentingviewcontroller-returns-the-parent-of-the-actual-presenting-view-contro
    var isLaterDate: Bool = false
    let stack = CoreDataStack.sharedInstance
    var transactionTitle: String?
    var transactionDate: Date?
    var amount: Double?
    var tagsFetchRequest : NSFetchRequest<Tag>?
    var oldTransaction : TransactionStruct?
    var newTransaction : TransactionStruct?
    var saveDelegate: SaveObjectDelegate?
    var isEditingTags : Bool = false {
        didSet {
            addNewTagButton.isHidden = isEditingTags
        }
    }
    var updatedValue = false {
        didSet {
            if updatedValue {
                self.saveButton.isEnabled = true
            }
        }
    }
    
    var fetchedResultsController : NSFetchedResultsController<Tag>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            
            fetchTags()
            fetchedResultsController?.delegate = self
            tagsTableView.dataSource = self
            tagsTableView.reloadData()
        }
    }
    
    // MARK: Outlets

    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var incomeSwitch: UISwitch!
    @IBOutlet weak var tagsTableView: UITableView!
    @IBOutlet weak var editTagsButton: UIButton!
    @IBOutlet weak var addNewTagButton: AddButton!
    @IBOutlet weak var topTableViewConstraint: NSLayoutConstraint!
    @IBOutlet var dateLabel: UIView!
    
    // MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let transaction = transaction {
            transactionTitle = transaction.title
            transactionDate = transaction.date as? Date
            amount = transaction.amount
            isIncome = transaction.income
            
            oldTransaction = TransactionStruct(description: transaction.title!, amount: transaction.amount, date: transaction.date! as Date, income: transaction.income)
        }
        
        addNewTagButton.isHidden = isEditingTags
        
        saveButton.isEnabled = false
        
        configureTextField(descriptionTextField)
        configureTextField(amountTextField)
        
        setUpView()
        
        tagsTableView.register(UINib(nibName: "TagCellView", bundle: nil), forCellReuseIdentifier: "TagCell")
    
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        incomeSwitch.addTarget(self, action: #selector(switchValueChanged), for: UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("walletVC transVC : \(walletVC)")
    }
    
    // MARK: Actions

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
            
            transaction!.date = transactionDate as! NSDate
            transaction!.amount = amount!
            transaction!.title = transactionTitle
            transaction!.income = isIncome!
            
            if isLaterDate {
                walletVC?.getNextTransaction(fromTransaction: transaction!) { (result) in
                    self.saveDelegate?.saveObject(controller: self, saveObject: result!, isNew: false)
                }
            } else {
                saveDelegate?.saveObject(controller: self, saveObject: transaction!, isNew: false)
            }

        } else {
            
            let new = Transaction(title: descriptionTextField.text!, amount: amount!, income: isIncome!, date: transactionDate! as NSDate , context: stack.context)
            saveDelegate?.saveObject(controller: self, saveObject: new, isNew: true)
            
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editTagsPressed(_ sender: Any) {
        isEditingTags = !isEditingTags
        editTagsButton.titleLabel?.text = isEditingTags ? "Done" : "Edit"
        setFetchRequest()
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        resignIfFirstResponder(descriptionTextField)
        resignIfFirstResponder(amountTextField)
    }
    
    @IBAction func addNewTag(_ sender: Any) {
    }
    // MARK: Obj-C selectors
    
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // Transaction date was changed to a later date
        if oldTransaction?.date?.compare(sender.date) == ComparisonResult.orderedAscending {
            isLaterDate = true
        }
        
        transactionDate = sender.date
        
        if let transaction = transaction {
            if transactionDate != (transaction.date as Date?) {
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
                saveButton.isEnabled = ((transaction.date! as Date) != transactionDate) || (transaction.title != transactionTitle) || (transaction.amount != amount)
            }
        } else {
            saveButton.isEnabled = (amount != nil) && (transactionTitle != nil)
        }
        
    }
    
    // MARK: Methods


    
    func setUpView() {
        
        if transaction != nil {
            
            datePicker.date = transactionDate!
            descriptionTextField.text = transactionTitle
            amountTextField.text = "\(amount!)"
            incomeSwitch.isOn = isIncome!
            
        } else {
            
            transactionDate = Date().simpleFormat
            datePicker.date = transactionDate!
            incomeSwitch.isOn = false
        }
        
    }
    
    func configureTextField(_ textField: UITextField) {
        
        textField.delegate = self
        textField.returnKeyType = UIReturnKeyType.done
        
    }
    
    func setFetchRequest() {
        
        tagsFetchRequest = NSFetchRequest<Tag>(entityName: "Tag")
        
        if let existingTransaction = transaction {
            if !isEditingTags {
                tagsFetchRequest?.predicate = NSPredicate(format: "transaction = %@", argumentArray: [existingTransaction])
            }
            
        }
        
        tagsFetchRequest?.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: tagsFetchRequest!, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Tag>
    }
    
    func fetchTags() -> [Tag] {
        var tags = [Tag]()
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                tags = fc.fetchedObjects!
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }

        return tags
    }
}
 
 extension TransactionVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchTags().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tag = fetchedResultsController?.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell") as! TagCell

        cell.tagNameLabel.text = tag?.name
        
        return cell
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
                saveButton.isEnabled = ((transaction.date! as Date) != transactionDate) || (transaction.income != isIncome)
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
