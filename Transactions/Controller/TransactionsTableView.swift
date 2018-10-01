//
//  TransactionsTableView.swift
//  Ewok
//
//  Created by Arturo Reyes on 9/2/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//
private let fixedString = "The amount of a fixed transaction is always the same."
private let variableString = "The amount of a variable transaction can vary so an average is calculated from every posted amount to calculate further budget predictions."

import Foundation
import UIKit

// MARK: - Table view data source and delegate

extension TransactionDetailVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sections: Int = 2
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var rows: Int = 0
        
        switch section {
            
        case 0:
            rows = 4
        case 1:
            let tagsAmount = tagList.count
            rows = (tagsAmount != 0) ? tagsAmount : 1
        default:
            break
        }
        
        return rows
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.backgroundView?.backgroundColor = .clear
    }
    
    //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //        var cellHeight : CGFloat = 60
    //
    //        if indexPath == IndexPath(row: 0, section: 0) {
    //            cellHeight = 130
    //        }
    //        return cellHeight
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateCellIndex {
            showCalendar(dateRangeType: .single)
        }
        //detailsTableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 {
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
        } else if indexPath.section == 1 {
            if tagList.count == 0 {
                let zeroTagsCell = UITableViewCell(style: .value1, reuseIdentifier: nil)
                zeroTagsCell.selectionStyle = .none
                zeroTagsCell.textLabel?.text = "Transaction has not been tagged yet."
                zeroTagsCell.textLabel?.textColor = .white
                zeroTagsCell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                
                cell = zeroTagsCell
                
            } else {
                let tagCell = tableView.dequeueReusableCell(withIdentifier: "TransactionTagCell", for: indexPath)
                let tag = tagList[indexPath.row]
                tagCell.textLabel?.text = tag.name
                tagCell.textLabel?.textColor = .white
                
                cell = tagCell
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let tagHeader = UITableViewCell(style: .value1, reuseIdentifier: nil)
            tagHeader.selectionStyle = .none
            tagHeader.textLabel?.text = "Tags"
            tagHeader.textLabel?.textColor = .white
            tagHeader.textLabel?.font = UIFont.systemFont(ofSize: 20)
            tagHeader.detailTextLabel?.text = "Edit"
            tagHeader.detailTextLabel?.textColor = .white
            tagHeader.imageView?.image = UIImage(named: "icons_tag.png")
            tagHeader.detailTextLabel?.isUserInteractionEnabled = true
            
            let editTagsGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showTagsVC(_:)))
            tagHeader.detailTextLabel?.addGestureRecognizer(editTagsGestureRecognizer)
            
            return tagHeader
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 50
        }
        return 0
    }
    
    private func loadAmountCell(_ cell: UITableViewCell) -> AmountCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "AmountCell") as? AmountCell
        cell?.amountTextField.delegate = cashDelegate
        cell?.amountTextField.adjustsFontSizeToFitWidth = false
        cell?.amountTextField.addDoneButtonOnKeyboard()
        //        cell?.valueSegmentControl.tintColor = amountColor
        cell?.valueSegmentControl.addTarget(self, action: #selector(changeValue), for: UIControl.Event.valueChanged)
        cell?.selectionStyle = .none
        
        
        if existingTransaction != nil {
            if let transactionAmount = transactionCopy?.amount, let isIncome = transactionCopy?.income {
                cell?.valueSegmentControl.selectedSegmentIndex = isIncome ? 0 : 1
                let amountString = transactionAmount.hasTwoDecimals ? "\(transactionAmount)" : "\(transactionAmount)0"
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
        descriptionTextField?.attributedPlaceholder = NSAttributedString(string: "Enter transaction description here", attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
        
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
                cell?.textLabel?.text = Date().simpleFormat.longFormatString
            }
        }
        
        guard let dateCell = cell else { return UITableViewCell() }
        return dateCell
    }
    
    private func loadRecurrentCell() -> UITableViewCell {
        let cell = detailsTableView.dequeueReusableCell(withIdentifier: "RecurrentCell") as? RecurrentCell
        cell?.recurrentSwitch.addTarget(self, action: #selector(recurrentValueChanged), for: UIControl.Event.valueChanged)
        cell?.fixedOrVariableControl.addTarget(self, action: #selector(variableValueChanged), for: UIControl.Event.valueChanged)
        setFrequencyOptionsRecognizers(cell)
        
        cell?.monthDayPicker.dataSource = monthDayPickerProtocol
        cell?.monthDayPicker.delegate = monthDayPickerProtocol
        cell?.byPeriodPicker.dataSource = periodPickerProtocol
        cell?.byPeriodPicker.delegate = periodPickerProtocol
        
        let currentTransaction = isNewTransaction ? newTransaction : transactionCopy
        var dateListString = "On specific dates: "
        
        if let dateList = currentTransaction?.frequencyInfo?.dates {
            for date in dateList {
                dateListString.append(date.shortFormatString + ", ")
            }
        }
        
        cell?.specificDatesLabel.text = dateListString
        
        
        if let isRecurrent = currentTransaction?.recurrent {
            cell?.recurrentSwitch.isOn = isRecurrent
            cell?.state = isRecurrent ? .expanded : .collapsed
        }
        
        if let isVariable = currentTransaction?.variable {
            cell?.fixedOrVariableControl.selectedSegmentIndex = isVariable ? 1 : 0
            cell?.fixedOrVariableDescriptionLabel.text = isVariable ? variableString : fixedString
        }
        
        if let freqInfo = currentTransaction?.frequencyInfo {
            cell?.frequencyType = freqInfo.frequencyType
            if var dayRow = freqInfo.monthDay {
                dayRow = dayRow - 1
                cell?.monthDayPicker.selectRow(dayRow, inComponent: 0, animated: false)
            }
            
            if var daysRow = freqInfo.period?.value {
                daysRow = daysRow - 1
                cell?.byPeriodPicker.selectRow(daysRow, inComponent: 0, animated: false)
            }
            
            if let periodTypeRow = freqInfo.period?.periodType {
                cell?.byPeriodPicker.selectRow(periodTypeRow.rawValue, inComponent: 1, animated: false)
            }
            
        } else {
            cell?.frequencyType = .byMonthDay
        }
        
        
        
        guard let recurrentCell = cell else { return UITableViewCell() }
        return recurrentCell
    }
    
//    private func loadAddTagsCell() -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
//        //cell.imageView?.image = UIImage(named: "icons_tag.png")
//        cell.textLabel?.text = "Add Tags"
//        cell.textLabel?.textColor = .white
//        return cell
//    }
    
    private func createTextField() -> UITextField {
        let textField =  UITextField(frame: CGRect(x: 20, y: 0, width: 300, height: 60))
        textField.font = UIFont.systemFont(ofSize: 18)
        textField.textColor = .white
        textField.borderStyle = UITextField.BorderStyle.none
        textField.backgroundColor = .clear
        textField.autocorrectionType = UITextAutocorrectionType.no
        textField.keyboardType = UIKeyboardType.default
        textField.returnKeyType = UIReturnKeyType.done
        textField.clearButtonMode = UITextField.ViewMode.whileEditing;
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        textField.delegate = self
        return textField
    }
    
    private func setFrequencyOptionsRecognizers(_ cell: RecurrentCell?) {
        let monthDayRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectMonthDay(_:)))
        let periodRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectByPeriod(_:)))
        let datesRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectByDates(_:)))
        
        cell?.monthDayView.addGestureRecognizer(monthDayRecognizer)
        cell?.byPeriodView.addGestureRecognizer(periodRecognizer)
        cell?.specificDatesView.addGestureRecognizer(datesRecognizer)
    }

    
}
