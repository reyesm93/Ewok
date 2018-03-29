//
//  CalendarModel.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/28/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

enum MonthIndex : Int {
    case january = 0, february, march, april, may, june, july, august, september, october, november, december
}

enum Weekdays : Int {
    case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
}

struct Month {
    let name : String
    var length : Int
    var firstWeekDay : Int
    let numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    init(index: MonthIndex, year: Int) {
        
        //for leap years set Feb length to 29 days
        if (index.rawValue) == 1 && year % 4 == 0 {
            length = 29
        } else {
            length = numOfDaysInMonth[index.rawValue]
        }
        
        firstWeekDay = ("\(year)-\(index.rawValue+1)-01".date?.firstDayOfTheMonth.weekday)!
        
        switch index {
        case .january:
            name = "January"
        case .february:
            name = "February"
        case .march:
            name = "March"
        case .april:
            name = "April"
        case .may:
            name = "May"
        case .june:
            name = "June"
        case .july:
            name = "July"
        case .august:
            name = "August"
        case .september:
            name = "September"
        case .october:
            name = "October"
        case .november:
            name = "November"
        case .december:
            name = "December"
        }
        
    }
}

class CalendarModel : NSObject {
    
    var today = Date()
    let secondsInYear = 31536000.0
    let years = 10.0
    var tenYearsAgo : Date?
    var tenYearsAhead : Date?
    var yearArray = [Int]()
    var monthArray = [[Month]]()
    
    override init() {
        super.init()
        self.createCalendar()
    }
    
    func setCalendarYears() {
        tenYearsAgo = Date(timeInterval: -(years*secondsInYear), since: today)
        tenYearsAhead = Date(timeInterval: (years*secondsInYear), since: today)
        
        let sinceYear = Calendar.current.component(.year, from: tenYearsAgo!)
        let toYear = Calendar.current.component(.year, from: tenYearsAhead!)
        
        for year in sinceYear...toYear {
            yearArray.append(year)
        }

    }
    
    func createCalendar() {
        
        setCalendarYears()
        
        for year in yearArray {
            
            for i in 0...11 {
                let monthIndex = MonthIndex(rawValue: i)
                let month = Month(index: monthIndex!, year: year)
                monthArray.append([month])
            }
        }
        
    }
}

extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    var firstDayOfTheMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year,.month], from: self))!
    }
}

//get date from string
extension String {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    var date: Date? {
        return String.dateFormatter.date(from: self)
    }
}
