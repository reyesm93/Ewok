//
//  Wallet+CoreDataClass.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Wallet)
public class Wallet: NSManagedObject {
    
    convenience init(walletName: String, balance: Double, dateCreated: NSDate, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Wallet", in: CoreDataStack.sharedInstance.context) {
            self.init(entity: entity, insertInto: CoreDataStack.sharedInstance.context)
            self.walletName = walletName
            self.dateCreated = dateCreated
            self.balance = balance
        } else {
            fatalError("Unable to find Entity name")
        }
    }
}
 
