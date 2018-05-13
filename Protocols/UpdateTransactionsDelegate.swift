//
//  AddViewControllerDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/17/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol UpdateTransactionsDelegate: class {
    func updateTransactionList(controller : UIViewController, saveObject: NSManagedObject, isNew: Bool)
    
}

