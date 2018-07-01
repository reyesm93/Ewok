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
    
    //MARK: Properties
    
    var mainHeight: CGFloat?
    var mainWidth: CGFloat?
    var transaction: Transaction?
    let cashDelegate = CashTextFieldDelegate(fontSize: 46, fontColor: .white)

    //MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainHeight = view.frame.height
        mainWidth = view.frame.width
    
        setTableView()
        
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
            cellHeight = 180
        }
        return cellHeight
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
        cell?.amountTextField.delegate = self.cashDelegate
        cell?.amountTextField.adjustsFontSizeToFitWidth = false
        cell?.amountTextField.addDoneButtonOnKeyboard()
        cell?.selectionStyle = .none
        
        
        if transaction != nil {
            if let transactionAmount = transaction?.amount {
                cell?.amountTextField.attributedText = "\(transactionAmount)0".cashAttributedString(color: .white, size: 46)
            }
        } else {
            cell?.amountTextField.attributedText = "$0.00".cashAttributedString(color: .white, size: 46)
        }
        
        return cell!
    }
    
    private func loadNameCell() -> UITableViewCell {
        
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "TransacionDetailCell")
        cell?.selectionStyle = .none
        let nameTextField = createTextField()
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Enter transaction description here", attributes: [NSAttributedStringKey.foregroundColor:UIColor.lightGray])

        if let transactionName = transaction?.title {
            nameTextField.text = transactionName
        }
        
        cell?.contentView.addSubview(nameTextField)
        
        if let cellBottom = cell?.contentView.bottomAnchor, let cellTop = cell?.contentView.topAnchor {
            nameTextField.bottomAnchor.constraint(equalTo: cellBottom).isActive = true
            nameTextField.topAnchor.constraint(equalTo: cellTop).isActive = true
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
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        transaction?.title = textField.text
    }

}
