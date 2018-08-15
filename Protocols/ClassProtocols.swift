//
//  AddViewControllerDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/17/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import CoreData
import UIKit

protocol SaveObjectDelegate: class {
    func saveObject(controller : UIViewController, saveObject: NSManagedObject, isNew: Bool, completionHandlerForSave: @escaping (_ didSave: Bool) -> Void)
}

protocol SelectedSectionDelegate: class {
    func selectedSection(viewController: UIViewController)
}

protocol SelectedDatesDelegate: class {
    func selectedDates(viewController: UIViewController, dates: [Date], rangeType: DateRangeType, afterDate: Bool?)
}
