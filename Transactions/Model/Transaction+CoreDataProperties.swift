//
//  Transaction+CoreDataProperties.swift
//  
//
//  Created by Arturo Reyes on 6/9/18.
//
//

import Foundation
import CoreData


extension Transaction {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }

    @NSManaged public var amount: Double
    @NSManaged public var date: NSDate?
    @NSManaged public var income: Bool
    @NSManaged public var newBalance: Double
    @NSManaged public var recurrent: Bool
    @NSManaged public var title: String?
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
