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
    
    @IBOutlet weak var contentCellView: UIView!
    @IBOutlet weak var transDescription: UILabel!
    @IBOutlet weak var transAmount: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var stackview: UIStackView!
    
}
