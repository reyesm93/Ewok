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
    
    convenience init(title: String, amount: Double, income: Bool, date: NSDate, context: NSManagedObjectContext, recurrent: Bool? = false, variable: Bool? = false, tags: NSSet? = nil) {
        if let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: CoreDataStack.sharedInstance.context) {
            self.init(entity: entity, insertInto: CoreDataStack.sharedInstance.context)
            self.title = title
            self.amount = amount
            self.income = income
            self.date = date
            self.recurrent = recurrent ?? false
            self.variable = variable ?? false
            self.tags = tags
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
    
    func updateWithStructCopy(_ copy: TransactionCopy) {
        self.title = copy.description
        self.amount = copy.amount ?? self.amount
        self.income = copy.income ?? self.income
        self.date = copy.date as NSDate?
        self.recurrent = copy.recurrent ?? self.recurrent
        self.variable = copy.variable ?? self.variable
        
        if let freqInfo = copy.frequencyInfo {
            var freqMonthDay: Int?
            var freqPeriod: FrequencyPeriod?
            var freqDates: [Date]?
            
            if freqInfo.monthDay != nil {
                freqMonthDay = freqInfo.monthDay
            }
            
            if freqInfo.period != nil {
                freqPeriod = FrequencyPeriod((freqInfo.period?.value)!, (freqInfo.period?.periodType)!)
            }
            
            if freqInfo.dates != nil {
                freqDates = freqInfo.dates
            }
            
            self.frequencyInfo = FrequencyInfo(frequencyType: freqInfo.frequencyType, monthDay: freqMonthDay, period: freqPeriod, dates: freqDates)
        }
    }

}
