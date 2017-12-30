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
    
    convenience init(walletName: String, balance: Float, createdAt: NSDate, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Wakket", in: CoreDataStack.sharedInstance.context) {
            self.init(entity: entity, insertInto: CoreDataStack.sharedInstance.context)
            self.walletName = walletName
            self.balance = balance
            self.createdAt = createdAt
        } else {
            fatalError("Unable to find Entity name")
        }
    }
}
