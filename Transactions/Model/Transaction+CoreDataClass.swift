//
//  Transaction+CoreDataClass.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject {
    
    convenience init(title: String, amount: Double, income: Bool, date: NSDate, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: CoreDataStack.sharedInstance.context) {
            self.init(entity: entity, insertInto: CoreDataStack.sharedInstance.context)
            self.title = title
            self.amount = amount
            self.income = income
            self.date = date
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    func updateWithStructCopy(_ copy: TransactionStruct) {
        self.title = copy.description
        self.amount = copy.amount ?? self.amount
        self.income = copy.income ?? self.income
        self.date = copy.date as? NSDate
    }

}
