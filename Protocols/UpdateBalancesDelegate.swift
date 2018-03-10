//
//  UpdateBalancesDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/8/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol UpdateBalancesDelegate: class {
    
    func updateBalances(controller: UIViewController, updateBalances fromTransaction: NSManagedObject, oldValues: TransactionStruct, newValues: TransactionStruct)
}
