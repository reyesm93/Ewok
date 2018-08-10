//
//  TransactionViewCell.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

class TransactionViewCell : UITableViewCell {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var newBalanceLabel: UILabel!
    
}

class AmountCell : UITableViewCell {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var valueSegmentControl: UISegmentedControl!
}

class RecurrentCell: UITableViewCell {
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    @IBOutlet weak var recurrentLabel: UILabel!
    @IBOutlet weak var recurrentSwitch: UISwitch!
    
    @IBOutlet weak var fixedOrVariableDescriptionLabel: UILabel!
    @IBOutlet weak var fixedOrVariableControl: UISegmentedControl!
    
    @IBOutlet weak var frequencyLabel: UILabel!
    
    @IBOutlet weak var monthDayLabel: UILabel!
    @IBOutlet weak var monthDayPicker: UIPickerView!
    @IBOutlet weak var monthDayCheckmark: UIImageView!
    @IBOutlet weak var monthDayView: UIView!
    @IBOutlet weak var theLabel: UILabel!
    
    @IBOutlet weak var byPeriodLabel: UILabel!
    @IBOutlet weak var byPeriodPicker: UIPickerView!
    @IBOutlet weak var byPeriodCheckmark: UIImageView!
    @IBOutlet weak var byPeriodView: UIView!
    
    @IBOutlet weak var specificDatesCheckmark: UIImageView!
    @IBOutlet weak var specificDatesLabel: UILabel!
    @IBOutlet weak var specificDatesView: UIView!
    
    private let expandedViewIndex: Int = 1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        tintColor = .white
        recurrentLabel.textColor = tintColor
        fixedOrVariableControl.tintColor = tintColor
        frequencyLabel.textColor = tintColor
        monthDayLabel.textColor = .lightGray
        monthDayCheckmark.tintColor = tintColor
        monthDayPicker.tintColor = tintColor
        recurrentSwitch.tintColor = tintColor
        byPeriodPicker.tintColor = tintColor
        byPeriodCheckmark.tintColor = tintColor
        specificDatesCheckmark.tintColor = tintColor
        byPeriodLabel.textColor = .lightGray
        specificDatesLabel.textColor = .lightGray
        theLabel.textColor = .lightGray
        
    }
    enum CellState {
        case collapsed
        case expanded
    }
    
    var state: CellState = .collapsed {
        didSet {
            toggleState()
        }
    }
    
    var frequencyType: FrequencyType = .byMonthDay {
        didSet {
            monthDayCheckmark.isHidden = true
            byPeriodCheckmark.isHidden = true
            specificDatesCheckmark.isHidden = true
            
            switch frequencyType {
            case .byMonthDay:
                monthDayCheckmark.isHidden = false
            case .byPeriod:
                byPeriodCheckmark.isHidden = false
            case .byDates:
                specificDatesCheckmark.isHidden = false
            }
        }
    }
    
//    @IBAction func selectMonthDay(_ sender: Any) {
//        frequencyType = .byMonthDay
//    }
//
//    @IBAction func selectPeriod(_ sender: Any) {
//        frequencyType = .byPeriod
//    }
//
//    @IBAction func selectByDates(_ sender: Any) {
//        frequencyType = .byDates
//    }
    
    private func toggleState() {
        mainStackView.arrangedSubviews[expandedViewIndex].isHidden = stateIsCollapsed()
    }
    
    private func stateIsCollapsed() -> Bool {
        return state == .collapsed
    }
}
