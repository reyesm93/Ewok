//
//  TransactionDetailTVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/29/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class TransactionDetailVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var detailsTableView: UITableView!
    @IBOutlet var dismissGestureRecognizer: UITapGestureRecognizer!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveButtonBottomConstraint: NSLayoutConstraint!
    
    //MARK: Properties
    
    var mainHeight: CGFloat?
    var mainWidth: CGFloat?
    weak var existingTransaction: Transaction?
    weak var walletVC: WalletVC?
    let stack = CoreDataStack.sharedInstance
    var newTransaction: TransactionStruct?
    var transactionCopy: TransactionStruct?
    var cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: .white)
    var saveDelegate: SaveObjectDelegate?
    var isNewTransaction: Bool = false
    var amountColor: UIColor = UIColor.white
    var descriptionTextField: UITextField?
    let dateCellIndex = IndexPath(row: 2, section: 0)
    var isLaterDate: Bool = false
    var shouldShowSaveButton = false {
        didSet {
            if shouldShowSaveButton {
                saveButton.isEnabled = true
                UIView.animate(withDuration: 1) {
                    self.saveButtonBottomConstraint.constant = 0
                }
                
            } else {
                saveButton.isEnabled = false
                UIView.animate(withDuration: 1) {
                    self.saveButtonBottomConstraint.constant = -1 * self.saveButton.frame.height
                }
                
            }
        }
    }

    //MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTransactionCopies()
        setUI()
        setTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDate(notification:)), name: NSNotification.Name(rawValue: "SendDates"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTransactionAmount(notification:)), name: NSNotification.Name(rawValue: "UpdateAmountTransaction"), object: nil)
    }
    
    //MARK: Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if isTransactionReadyToSave() {
            
            if existingTransaction != nil && !isNewTransaction && transactionCopy != nil {
                existingTransaction?.updateWithStructCopy(transactionCopy!)
                if isLaterDate {
                    walletVC?.getNextTransaction(fromTransaction: existingTransaction!) { (result) in
                        // check what happens if you only have one transaction and you change to a later date
                        self.saveDelegate?.saveObject(controller: self, saveObject: result!, isNew: false)
                    }
                } else {
                    saveDelegate?.saveObject(controller: self, saveObject: existingTransaction!, isNew: false)
                }
            } else if newTransaction != nil && isNewTransaction {
                guard let newName = newTransaction?.description, let newAmount = newTransaction?.amount, let newIncome = newTransaction?.income, let newDate = newTransaction?.date as NSDate? else { return }
                let createTransaction = Transaction(title: newName, amount: newAmount, income: newIncome, date: newDate, context: stack.context)
                saveDelegate?.saveObject(controller: self, saveObject: createTransaction, isNew: true)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func userDidTapView(_ sender: Any) {
        if descriptionTextField != nil {
            resignIfFirstResponder(descriptionTextField!)
        }
    }
    
    // MARK: Methods
    
    fileprivate func setUI() {
        mainHeight = view.frame.height
        mainWidth = view.frame.width
        dismissGestureRecognizer.isEnabled = false
        shouldShowSaveButton = isTransactionReadyToSave()
        //        detailsTableView.heightAnchor.constraint(equalToConstant: mainHeight!)
    }
    
    fileprivate func setTransactionCopies() {
        if existingTransaction != nil {
            isNewTransaction = false
            transactionCopy = TransactionStruct(with: existingTransaction!)
            guard let isIncome = transactionCopy?.income else { return }
            amountColor = isIncome ? UIColor.white : UIColor.red
            cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: amountColor)
        } else {
            newTransaction = TransactionStruct(date: Date(), income: true)
            isNewTransaction = true
            cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: .white)
        }
    }
    
    private func setTableView() {
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(UINib(nibName: "AmountCell", bundle: nil), forCellReuseIdentifier: "AmountCell")
//        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.estimatedRowHeight = 200
        
        let gradientView = GradientView()
        gradientView.FirstColor = UIColor.black
        gradientView.SecondColor = UIColor.darkGray
        detailsTableView.backgroundView = gradientView
    }
    
    private func showCalendar() {
        if let vc = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            vc.definesPresentationContext = true
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.allowsMultipleDates = false
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    private func setIncome(_ bool: Bool) {
        if isNewTransaction && newTransaction != nil {
            newTransaction?.income = bool
            if var currentAmount = newTransaction?.amount {
                if (bool && currentAmount < 0) || (!bool && currentAmount > 0) {
                    currentAmount *= -1
                    newTransaction?.amount = currentAmount
                }
            }
        } else if !isNewTransaction && existingTransaction != nil {
            transactionCopy?.income = bool
            if var currentAmount = transactionCopy?.amount {
                if (bool && currentAmount < 0) || (!bool && currentAmount > 0) {
                    currentAmount *= -1
                    transactionCopy?.amount = currentAmount
                }
            }
        }
    }
    
    fileprivate func setOrRemoveNegativeSign(_ isPositive: Bool, _ updatedText: inout String?) {
        if isPositive && (updatedText?.hasPrefix("-"))! {
            updatedText = String((updatedText?.dropFirst())!)
        } else if !isPositive && !(updatedText?.hasPrefix("-"))! && updatedText != "$0.00" {
            updatedText = "-" + updatedText!
        }
    }
    
    fileprivate func setSignPrefix(_ updatedText: inout String?) {
        if isNewTransaction, let isPositive = newTransaction?.income {
            setOrRemoveNegativeSign(isPositive, &updatedText)
        } else if !isNewTransaction, let isPositive = transactionCopy?.income {
            setOrRemoveNegativeSign(isPositive, &updatedText)
        }
    }
    
    private func updateAmountTextField(updatedText: String? = nil, isIncome: Bool? = nil) {
        var updatedText = updatedText
        let cellIndex = IndexPath(row: 0, section: 0)
        if let amountCell = detailsTableView.cellForRow(at: cellIndex) as? AmountCell {
            
            if isIncome != nil {
                amountColor = isIncome! ? UIColor.white : UIColor.red
            }
            
            if updatedText == "$0.00" {
                amountColor = UIColor.white
            }
            
            cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: amountColor)
            amountCell.amountTextField.delegate = cashDelegate
            
            if updatedText != nil {
                setSignPrefix(&updatedText)
                amountCell.amountTextField.attributedText = updatedText?.cashAttributedString(color: amountColor, size: 46)
            } else {
                var currentText = amountCell.amountTextField.attributedText?.string
                setSignPrefix(&currentText)
                amountCell.amountTextField.attributedText = currentText?.cashAttributedString(color: amountColor, size: 46)
            }
            
        }
    }
    
    private func isTransactionReadyToSave() -> Bool {
        if existingTransaction != nil && !isNewTransaction {
            if transactionCopy?.amount != 0.0  && transactionCopy?.description != "" {
                let updatedTransaction = TransactionStruct(with: existingTransaction!)
                return updatedTransaction != transactionCopy
            }
        } else if newTransaction != nil && isNewTransaction {
            if newTransaction?.amount != 0.0 && newTransaction?.amount != nil && newTransaction?.description != nil && newTransaction?.description != "" {
                return true
            }
        }
        
        return false
    }
    
    
    // MARK: Obj-C messages
    
    @objc func changeValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setIncome(true)
            updateAmountTextField(isIncome: true)
            //sender.tintColor = UIColor.blue
        case 1:
            setIncome(false)
            updateAmountTextField(isIncome: false)
            //sender.tintColor = UIColor.red
        default:
            break
        }
        
        shouldShowSaveButton = isTransactionReadyToSave()
    }
    
    @objc func updateDate(notification: Notification) {
        guard let chosenDate = notification.userInfo?["dates"] as! [Date]? else { return }
        
        if isNewTransaction && newTransaction != nil {
            newTransaction?.date = chosenDate[0]
        } else if !isNewTransaction && existingTransaction != nil {
            isLaterDate = transactionCopy?.date?.compare(chosenDate[0]) == ComparisonResult.orderedAscending
            transactionCopy?.date = chosenDate[0]
        }
        
        if let dateCell = detailsTableView.cellForRow(at: dateCellIndex) {
            dateCell.textLabel?.text = chosenDate[0].longFormatString
            detailsTableView.reloadRows(at: [dateCellIndex], with: .fade)
        }
        
        shouldShowSaveButton = isTransactionReadyToSave()
    }
    
    @objc func updateTransactionAmount(notification: Notification) {
        guard let updatedAmount = notification.userInfo?["updatedAmount"] as! String? else { return }
        guard var numberAmount = updatedAmount.convertCurrencytoDouble() as Double?  else { return }
        updateAmountTextField(updatedText: updatedAmount)
    
        if existingTransaction != nil, let isPositive = transactionCopy?.income {
            if !isPositive {
                numberAmount *= -1
            }
            transactionCopy?.amount = numberAmount
        } else {
            newTransaction?.amount = numberAmount
        }
        shouldShowSaveButton = isTransactionReadyToSave()
    }
}

    // MARK: - Table view data source and delegate

extension TransactionDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.backgroundView?.backgroundColor = .clear
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var cellHeight : CGFloat = 60
        
        if indexPath == IndexPath(row: 0, section: 0) {
            cellHeight = 130
        }
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateCellIndex {
            showCalendar()
        }
        //detailsTableView.reloadRows(at: [indexPath], with: .fade)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = loadAmountCell(cell)
        case 1:
            cell = loadNameCell()
        case 2:
            cell = loadDateCell()
        case 3:
            cell = loadRecurrentCell()
        default:
            break
        }
        
        return cell
    }
    
    private func loadAmountCell(_ cell: UITableViewCell) -> AmountCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "AmountCell") as? AmountCell
        cell?.amountTextField.delegate = cashDelegate
        cell?.amountTextField.adjustsFontSizeToFitWidth = false
        cell?.amountTextField.addDoneButtonOnKeyboard()
//        cell?.valueSegmentControl.tintColor = amountColor
        cell?.valueSegmentControl.addTarget(self, action: #selector(changeValue), for: UIControlEvents.valueChanged)
        cell?.selectionStyle = .none
        
        
        if existingTransaction != nil {
            if let transactionAmount = transactionCopy?.amount, let isIncome = transactionCopy?.income {
                cell?.valueSegmentControl.selectedSegmentIndex = isIncome ? 0 : 1
                let amountString = "\(transactionAmount)0"
                
                cell?.amountTextField.attributedText = amountString.cashAttributedString(color: amountColor, size: 46)
            }
        } else {
            cell?.amountTextField.attributedText = "$0.00".cashAttributedString(color: UIColor.white, size: 46)
        }
        
        return cell!
    }
    
    private func loadNameCell() -> UITableViewCell {
        
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "TransacionDetailCell")
        cell?.selectionStyle = .none
        descriptionTextField = createTextField()
        descriptionTextField?.attributedPlaceholder = NSAttributedString(string: "Enter transaction description here", attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightGray])

        if let transactionName = transactionCopy?.description {
            descriptionTextField?.text = transactionName
        }
        
        cell?.contentView.addSubview(descriptionTextField!)
        
        if let cellBottom = cell?.contentView.bottomAnchor, let cellTop = cell?.contentView.topAnchor {
            descriptionTextField?.bottomAnchor.constraint(equalTo: cellBottom).isActive = true
            descriptionTextField?.topAnchor.constraint(equalTo: cellTop).isActive = true
        }
        
        
        guard let textFieldCell = cell else { return UITableViewCell() }
        return textFieldCell
    }
    
    private func loadDateCell() -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "TransacionDetailCell")
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        if let transactionDate = transactionCopy?.date as Date? {
            cell?.textLabel?.text = transactionDate.longFormatString
        } else {
            if let newDate = newTransaction?.date {
               cell?.textLabel?.text = newDate.longFormatString
            } else {
                cell?.textLabel?.text = Date().longFormatString
            }
        }
        
        guard let dateCell = cell else { return UITableViewCell() }
        return dateCell
    }
    
    private func loadRecurrentCell() -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "TransacionDetailCell")
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        cell?.textLabel?.text = "Recurrent"
        let recurrentSwitch = UISwitch(frame: CGRect(x: 0, y: 0, width: 30, height: 40))
        cell?.accessoryView = recurrentSwitch
        
        guard let recurrentCell = cell else { return UITableViewCell() }
        return recurrentCell
    }
    
    private func createTextField() -> UITextField {
        let textField =  UITextField(frame: CGRect(x: 20, y: 0, width: 300, height: 60))
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .white
        textField.borderStyle = UITextBorderStyle.none
        textField.backgroundColor = .clear
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextFieldViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.delegate = self
        return textField
    }

}

extension TransactionDetailVC : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        dismissGestureRecognizer.isEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if existingTransaction != nil {
            transactionCopy?.description = textField.text
        } else {
            newTransaction?.description = textField.text
        }
        shouldShowSaveButton = isTransactionReadyToSave()
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        dismissGestureRecognizer.isEnabled = true
        return true
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
            dismissGestureRecognizer.isEnabled = false
        }
    }

}
