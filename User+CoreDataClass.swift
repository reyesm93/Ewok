//
//  User+CoreDataClass.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject {
    
    convenience init(firstName: String, lastName: String, email: String, createdAt: NSDate, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "User", in: CoreDataStack.sharedInstance.context) {
            self.init(entity: entity, insertInto: CoreDataStack.sharedInstance.context)
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.createdAt = createdAt
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
