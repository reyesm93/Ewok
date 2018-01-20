//
//  EwokUser+CoreDataProperties.swift
//  
//
//  Created by Arturo Reyes on 1/20/18.
//
//

import Foundation
import CoreData


extension EwokUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EwokUser> {
        return NSFetchRequest<EwokUser>(entityName: "EwokUser")
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
extension EwokUser {

    @objc(addWalletsObject:)
    @NSManaged public func addToWallets(_ value: Wallet)

    @objc(removeWalletsObject:)
    @NSManaged public func removeFromWallets(_ value: Wallet)

    @objc(addWallets:)
    @NSManaged public func addToWallets(_ values: NSSet)

    @objc(removeWallets:)
    @NSManaged public func removeFromWallets(_ values: NSSet)

}
