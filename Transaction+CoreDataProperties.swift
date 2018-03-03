//
//  Transaction+CoreDataProperties.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/30/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var createdAt: NSDate?
    @NSManaged public var income: Bool
    @NSManaged public var newBalance: Double
    @NSManaged public var scheduled: Bool
    @NSManaged public var title: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var variable: Bool
    @NSManaged public var tags: NSSet?
    @NSManaged public var wallet: Wallet?

}

// MARK: Generated accessors for tags
extension Transaction {

    @objc(addTagsObject:)
    @NSManaged public func addToTags(_ value: Tag)

    @objc(removeTagsObject:)
    @NSManaged public func removeFromTags(_ value: Tag)

    @objc(addTags:)
    @NSManaged public func addToTags(_ values: NSSet)

    @objc(removeTags:)
    @NSManaged public func removeFromTags(_ values: NSSet)

}
