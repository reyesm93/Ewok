//
//  TransactionDetailTVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/29/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

enum CellTypeIndex: Int {
    case amount, name, date, recurring
    
    
}

class TransactionDetailVC: UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var detailsTableView: UITableView!
//    @IBOutlet var dismissGestureRecognizer: UITapGestureRecognizer!
    
    //MARK: Properties
    
    var mainHeight: CGFloat?
    var mainWidth: CGFloat?
    weak var transaction: Transaction?
    var newTransaction: TransactionStruct?
    var cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: .white)
    var isNewTransaction: Bool = true
    var amountColor: UIColor = UIColor.white
    var nameTextField: UITextField?
    let dateCellIndex = IndexPath(row: 2, section: 0)

    //MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainHeight = view.frame.height
        mainWidth = view.frame.width
//        dismissGestureRecognizer.addTarget(self, action: #selector(dismissTextField))
//        dismissGestureRecognizer.isEnabled = false
        
        if transaction != nil {
            isNewTransaction = false
            guard let isIncome = transaction?.income else { return }
            amountColor = isIncome ? UIColor.green : UIColor.red
            cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: amountColor)
        } else {
            newTransaction = TransactionStruct(date: Date())
            isNewTransaction = true
        }
    
        setTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(updateDate(notification:)), name: NSNotification.Name(rawValue: "SendDates"), object: nil)
    }
    
    //MARK: Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
    }
    // MARK: Methods
    
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
    
    // MARK: Obj-C messages
    
    @objc func changeValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            setIncome(true)
            updateAmountColor(true)
            //sender.tintColor = UIColor.green
        case 1:
            setIncome(false)
            updateAmountColor(false)
            //sender.tintColor = UIColor.red
        default:
            break
        }
    }
    
    @objc func updateDate(notification: Notification) {
        guard let chosenDate = notification.userInfo?["dates"] as! [Date]? else { return }
        
        if isNewTransaction && newTransaction != nil {
            newTransaction?.date = chosenDate[0]
        } else if !isNewTransaction && transaction != nil {
            transaction?.date = chosenDate[0] as NSDate
        }
        
        if let dateCell = detailsTableView.cellForRow(at: dateCellIndex) {
            dateCell.textLabel?.text = chosenDate[0].longFormatString
            detailsTableView.reloadRows(at: [dateCellIndex], with: .fade)
        }
    }
    
    @IBAction func userDidTapView(_ sender: Any) {
        if nameTextField != nil {
            resignIfFirstResponder(nameTextField!)
        }
    }
    
//    @objc func dismissTextField(_ sender: Any) {
//        if nameTextField != nil {
//            resignIfFirstResponder(nameTextField!)
//        }
//    }
    
    private func setIncome(_ bool: Bool) {
        if isNewTransaction && newTransaction != nil {
            newTransaction?.income = bool
        } else if !isNewTransaction && transaction != nil {
            transaction?.income = bool
        }
    }
    
    private func updateAmountColor(_ bool: Bool) {
        let cellIndex = IndexPath(row: 0, section: 0)
        if let amountCell = detailsTableView.cellForRow(at: cellIndex) as? AmountCell {
            amountColor = bool ? UIColor.green : UIColor.red
            cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: amountColor)
            amountCell.amountTextField.delegate = cashDelegate
            let currentText = amountCell.amountTextField.attributedText?.string
            amountCell.amountTextField.attributedText = currentText?.cashAttributedString(color: amountColor, size: 46)
        }
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
            cellHeight = 160
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
        
        
        if transaction != nil {
            if let transactionAmount = transaction?.amount {
                cell?.amountTextField.attributedText = "\(transactionAmount)0".cashAttributedString(color: amountColor, size: 46)
            }
        } else {
            cell?.amountTextField.attributedText = "$0.00".cashAttributedString(color: amountColor, size: 46)
        }
        
        return cell!
    }
    
    private func loadNameCell() -> UITableViewCell {
        
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "TransacionDetailCell")
        cell?.selectionStyle = .none
        nameTextField = createTextField()
        nameTextField?.attributedPlaceholder = NSAttributedString(string: "Enter transaction description here", attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightGray])

        if let transactionName = transaction?.title {
            nameTextField?.text = transactionName
        }
        
        cell?.contentView.addSubview(nameTextField!)
        
        if let cellBottom = cell?.contentView.bottomAnchor, let cellTop = cell?.contentView.topAnchor {
            nameTextField?.bottomAnchor.constraint(equalTo: cellBottom).isActive = true
            nameTextField?.topAnchor.constraint(equalTo: cellTop).isActive = true
        }
        
        
        guard let textFieldCell = cell else { return UITableViewCell() }
        return textFieldCell
    }
    
    private func loadDateCell() -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "TransacionDetailCell")
        cell?.selectionStyle = .none
        cell?.textLabel?.textColor = .white
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
        
        if let transactionDate = transaction?.date as? Date {
            cell?.textLabel?.text = transactionDate.longFormatString
        } else {
            cell?.textLabel?.text = Date().longFormatString
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
//        dismissGestureRecognizer.isEnabled = false
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if transaction != nil {
            transaction?.title = textField.text
        } else {
            newTransaction?.description = textField.text
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        dismissGestureRecognizer.isEnabled = true
        return true
    }
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
//            dismissGestureRecognizer.isEnabled = false
        }
    }

}
