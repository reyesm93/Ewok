//
//  User+CoreDataProperties.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/29/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var createdAt: NSDate?
    @NSManaged public var date0fBirth: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var gender: String?
    @NSManaged public var lastName: String?
    @NSManaged public var updatedAt: NSDate?
    @NSManaged public var wallets: NSSet?

}

// MARK: Generated accessors for wallets
extension User {

    @objc(addWalletsObject:)
    @NSManaged public func addToWallets(_ value: Wallet)

    @objc(removeWalletsObject:)
    @NSManaged public func removeFromWallets(_ value: Wallet)

    @objc(addWallets:)
    @NSManaged public func addToWallets(_ values: NSSet)

    @objc(removeWallets:)
    @NSManaged public func removeFromWallets(_ values: NSSet)

}
