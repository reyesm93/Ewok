//
//  TransactionDetailTVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/29/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class TransactionDetailTVC: UITableViewController {
    
    var mainHeight: CGFloat?
    var transaction: Transaction?
    let cashDelegate = CashTextFieldDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()
        mainHeight = view.frame.height
        setTableView()
        
    }
    
    // MARK: Methods
    
    private func setTableView() {
        
        tableView.register(UINib(nibName: "AmountCell", bundle: nil), forCellReuseIdentifier: "AmountCell")
        
        let gradientView = GradientView()
        gradientView.FirstColor = UIColor.black
        gradientView.SecondColor = UIColor.darkGray
        tableView.backgroundView = gradientView
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.backgroundView?.backgroundColor = .clear
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            cell = loadAmountCell(cell)
        case 2:
            cell = loadCell()
        default:
            break
        }


        return cell
    }
    
    func loadAmountCell(_ cell: UITableViewCell) -> AmountCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AmountCell") as? AmountCell
        cell?.amountTextField.delegate = self.cashDelegate
        cell?.selectionStyle = .none
        
        if transaction != nil {
            if let transactionAmount = transaction?.amount {
                cell?.amountTextField.text = "\(transactionAmount)"
            }
            
        }
        
        return cell!
    }
    
    func loadCell() -> UITableViewCell {
        return UITableViewCell()
    }

}
//
//extension TransactionDetailTVC : UITextFieldDelegate {
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        <#code#>
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //
//    }
//
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        // when new transaction is added make amount textfield first responder
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//
//    }
//
//
//}
