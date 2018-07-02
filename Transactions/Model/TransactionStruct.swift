//
//  TransactionStruct.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/8/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation

struct TransactionStruct {
    
    var description: String?
    var amount: Double?
    var date: Date?
    var income: Bool?
    var recurrent: Bool?
    
    init(description: String? = nil, amount: Double? = nil, date: Date? = nil, income: Bool? = false, recurrent: Bool? = false) {
        self.description = description
        self.amount = amount
        self.date = date
        self.income = income
        self.recurrent = recurrent
    }
}
