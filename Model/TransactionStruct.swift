//
//  TransactionStruct.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/8/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation

struct TransactionStruct {
    
    var description: String
    var amount: Double
    var date: Date
    var income: Bool
    
    init(description: String, amount: Double, date: Date, income: Bool) {
        self.description = description
        self.amount = amount
        self.date = date
        self.income = income
    }
    
}
