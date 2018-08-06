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

struct TransactionStruct : Equatable {
    
    var description: String?
    var amount: Double?
    var date: Date?
    var income: Bool?
    var recurrent: Bool?
    var variable: Bool?
    
    init(description: String? = nil, amount: Double? = nil, date: Date? = nil, income: Bool? = false, recurrent: Bool? = false, variable: Bool? = false) {
        self.description = description
        self.amount = amount
        self.date = date
        self.income = income
        self.recurrent = recurrent
        self.variable = variable
    }
    
    init(with transaction: Transaction) {
        self.description = transaction.title
        self.amount = transaction.amount
        self.date = transaction.date as Date?
        self.income = transaction.income
        self.variable = transaction.variable
    }
    
    static func == (lhs: TransactionStruct, rhs: TransactionStruct) -> Bool {
        return (lhs.description == rhs.description) && (lhs.amount == rhs.amount) && (lhs.date == rhs.date) && (lhs.income == rhs.income)
    }
}


