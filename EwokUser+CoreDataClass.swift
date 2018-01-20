//
//  EwokUser+CoreDataClass.swift
//  
//
//  Created by Arturo Reyes on 1/20/18.
//
//

import Foundation
import CoreData

@objc(EwokUser)
public class EwokUser: NSManagedObject {
    
    convenience init(firstName: String, lastName: String, email: String, createdAt: NSDate, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "EwokUser", in: CoreDataStack.sharedInstance.context) {
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
