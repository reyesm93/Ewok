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
    
    @IBOutlet weak var monthDayCell: UITableViewCell!
    @IBOutlet weak var monthDayLabel: UILabel!
    @IBOutlet weak var monthDayPicker: UIPickerView!
    
    @IBOutlet weak var byPeriodCell: UITableViewCell!
    @IBOutlet weak var byPeriodPicker: UIPickerView!
    
    private let expandedViewIndex: Int = 1
    
    enum CellState {
        case collapsed
        case expanded
    }
    
    var state: CellState = .collapsed {
        didSet {
            toggle()
        }
    }
    
    private func toggle() {
        mainStackView.arrangedSubviews[expandedViewIndex].isHidden = stateIsCollapsed()
    }
    
    private func stateIsCollapsed() -> Bool {
        return state == .collapsed
    }
}
