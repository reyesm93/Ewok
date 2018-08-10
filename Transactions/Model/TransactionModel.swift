//
//  TransactionStruct.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/8/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation

enum FrequencyType : Int {
    case byMonthDay = 0, byPeriod, byDates
}

enum PeriodType: Int {
    case days = 0, weeks, months, years
    
    var description: String {
        switch self {
        case .days: return "days"
        case .weeks: return "weeks"
        case .months: return "months"
        case .years: return "years"
        }
    }
}


struct TransactionCopy : Equatable {
    
    var description: String?
    var amount: Double?
    var date: Date?
    var income: Bool?
    var recurrent: Bool?
    var variable: Bool?
    var frequencyInfo: FrequencyInfoCopy?
    
    init(description: String? = nil, amount: Double? = nil, date: Date? = nil, income: Bool? = false, recurrent: Bool? = false, variable: Bool? = false, frequencyInfo: FrequencyInfoCopy? = nil) {
        self.description = description
        self.amount = amount
        self.date = date
        self.income = income
        self.recurrent = recurrent
        self.variable = variable
        self.frequencyInfo = frequencyInfo
    }
    
    init(with transaction: Transaction) {
        self.description = transaction.title
        self.amount = transaction.amount
        self.date = transaction.date as Date?
        self.income = transaction.income
        self.variable = transaction.variable
        self.recurrent = transaction.recurrent
        self.variable = transaction.variable
        
        if let freqInfo = transaction.frequencyInfo {
            self.frequencyInfo = FrequencyInfoCopy(with: freqInfo as! FrequencyInfo)
        }
    }
    
    func createTransactionManagedObject() -> Transaction? {
        guard let description = self.description, let amount = self.amount, let income = self.income, let date = self.date, let recurrent = self.recurrent else { return nil}
        let newTransaction = Transaction(title: description, amount: amount, income: income, date: date as NSDate, context: CoreDataStack.sharedInstance.context, recurrent: recurrent)
        if let isVariable = self.variable {
            newTransaction.variable = isVariable
        }
        if let freqInfo = self.frequencyInfo {
            newTransaction.frequencyInfo = freqInfo.createFrequencyObject()
        }
        
        return newTransaction
    }
    
    static func == (lhs: TransactionCopy, rhs: TransactionCopy) -> Bool {
        return (lhs.description == rhs.description) && (lhs.amount == rhs.amount) && (lhs.date == rhs.date) && (lhs.income == rhs.income) && (lhs.recurrent == rhs.recurrent) && (lhs.variable == rhs.variable) && (lhs.frequencyInfo == rhs.frequencyInfo)
    }
}

final class FrequencyInfo : NSObject, NSCoding {

    var frequencyType: FrequencyType
    var monthDay: Int?
    var period: FrequencyPeriod?
    var dates: [Date]?

    init(frequencyType: FrequencyType, monthDay: Int? = nil, period: FrequencyPeriod? = nil, dates: [Date]? = nil) {
        self.frequencyType = frequencyType
        self.monthDay = monthDay
        self.period = period
        self.dates = dates
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.frequencyType.rawValue, forKey: "frequencyType")
        aCoder.encode(self.monthDay, forKey: "monthDay")
        aCoder.encode(self.period, forKey: "period")
        aCoder.encode(self.dates, forKey: "dates")

    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let freqTypeRaw = aDecoder.decodeObject(forKey: "frequencyType") as? Int else { return nil }
        guard let freqType = FrequencyType(rawValue: freqTypeRaw) else { return nil }
        
        self.init(frequencyType: freqType)
        self.monthDay = aDecoder.decodeInteger(forKey: "monthDay")
        self.period = aDecoder.decodeObject(forKey: "period") as? FrequencyPeriod
        self.dates =  aDecoder.decodeObject(forKey: "dates") as? [Date]
        
        
    }
    
    static func == (lhs: FrequencyInfo, rhs: FrequencyInfo) -> Bool {
        return (lhs.frequencyType == rhs.frequencyType) && (lhs.monthDay == rhs.monthDay) && (lhs.period == rhs.period) && (lhs.dates == rhs.dates)
    }
}

final class FrequencyPeriod: NSObject, NSCoding {
    
    var value: Int
    var periodType: PeriodType
    
    init(_ value: Int, _ periodType: PeriodType) {
        self.value = value
        self.periodType = periodType
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.value, forKey: "value")
        aCoder.encode(self.periodType.rawValue, forKey: "periodType")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let value = aDecoder.decodeInteger(forKey: "value")
        guard let type = aDecoder.decodeObject(forKey: "peiodType") as? PeriodType else { return nil }
        self.init(value, type)
        
    }
    
    static func == (lhs: FrequencyPeriod, rhs: FrequencyPeriod) -> Bool {
        return (lhs.value == rhs.value) && (lhs.periodType == rhs.periodType)
    }
}

struct FrequencyInfoCopy : Equatable {
    var frequencyType: FrequencyType
    var monthDay: Int?
    var period: FrequencyPeriodCopy?
    var dates: [Date]?
    
    init(frequencyType: FrequencyType, monthDay: Int? = nil, period: FrequencyPeriodCopy? = nil, dates: [Date]? = nil) {
        self.frequencyType = frequencyType
        self.monthDay = monthDay
        self.period = period
        self.dates = dates
        
    }
    
    init(with frequencyInfo: FrequencyInfo) {
        self.frequencyType = frequencyInfo.frequencyType
        self.monthDay = frequencyInfo.monthDay
        self.dates = frequencyInfo.dates
        
        if let freqPeriod = frequencyInfo.period {
            self.period = FrequencyPeriodCopy(with: freqPeriod)
        }
        
    }
    
    func createFrequencyObject() -> FrequencyInfo {
        return FrequencyInfo(frequencyType: self.frequencyType, monthDay: self.monthDay, period: self.period?.createPeriodObject(), dates: self.dates)
    }
    
    static func == (lhs: FrequencyInfoCopy, rhs: FrequencyInfoCopy) -> Bool {
        return (lhs.frequencyType == rhs.frequencyType) && (lhs.monthDay == rhs.monthDay) && (lhs.period == rhs.period) && (lhs.dates == rhs.dates)
    }
}

struct FrequencyPeriodCopy: Equatable {
    var value: Int
    var periodType: PeriodType
    
    init(_ value: Int, _ periodType: PeriodType) {
        self.value = value
        self.periodType = periodType
    }
    
    init(with frequencyPeriod: FrequencyPeriod) {
        self.value = frequencyPeriod.value
        self.periodType = frequencyPeriod.periodType
    }
    
    func createPeriodObject() -> FrequencyPeriod {
        return FrequencyPeriod(self.value, self.periodType)
    }
    
    static func == (lhs: FrequencyPeriodCopy, rhs: FrequencyPeriodCopy) -> Bool {
        return (lhs.value == rhs.value) && (lhs.periodType == rhs.periodType)
    }
    
    
}

