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

protocol CreateObjectDelegate: class {
    func createNewObject(controller : UIViewController, saveObject: NSManagedObject, isNew: Bool)
    
}

