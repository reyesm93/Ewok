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


struct TransactionStruct : Equatable {
    
    var description: String?
    var amount: Double?
    var date: Date?
    var income: Bool?
    var recurrent: Bool?
    var variable: Bool?
    var frequencyInfo: FrequencyInfo?
    
    init(description: String? = nil, amount: Double? = nil, date: Date? = nil, income: Bool? = false, recurrent: Bool? = false, variable: Bool? = false, frequencyInfo: FrequencyInfo? = nil) {
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
        self.frequencyInfo = transaction.frequencyInfo as? FrequencyInfo
    }
    
    static func == (lhs: TransactionStruct, rhs: TransactionStruct) -> Bool {
        return (lhs.description == rhs.description) && (lhs.amount == rhs.amount) && (lhs.date == rhs.date) && (lhs.income == rhs.income) && (lhs.recurrent == rhs.recurrent) && (lhs.variable == rhs.variable) && (lhs.frequencyInfo == rhs.frequencyInfo)
    }
}

final class FrequencyInfo : NSObject {
    
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
    
    static func == (lhs: FrequencyInfo, rhs: FrequencyInfo) -> Bool {
        return (lhs.frequencyType == rhs.frequencyType) && (lhs.monthDay == rhs.monthDay) && (lhs.period == rhs.period) && (lhs.dates == rhs.dates)
    }
}

struct FrequencyPeriod: Equatable {
    var value: Int
    var periodType: PeriodType
    
    init(_ value: Int, _ periodType: PeriodType) {
        self.value = value
        self.periodType = periodType
    }
}

