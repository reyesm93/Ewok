//
//  Tag+CoreDataClass.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Tag)
public class Tag: NSManagedObject {
    
    convenience init(name: String) {
        if let entity = NSEntityDescription.entity(forEntityName: "Tag", in: CoreDataStack.sharedInstance.context) {
            self.init(entity: entity, insertInto: CoreDataStack.sharedInstance.context)
            self.name = name
        }
    }
}
