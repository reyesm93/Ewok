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
    var year : Int
    var length : Int
    var firstWeekDay : Int
    let numOfDaysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]
    
    init(index: MonthIndex, year: Int) {
        self.year = year
        
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
    let years = 1.0
    var yearsAgo : Date?
    var yearsAhead : Date?
    var yearArray = [Int]()
    var monthArray = [Month]()
    var todayIndexPath : IndexPath?
    
    override init() {
        super.init()
        self.createCalendar()
        todayIndexPath = getDateIndexPath(date: Date(), monthArray: monthArray)
    }
    
    func setCalendarYears() {
        yearsAgo = Date(timeInterval: -(years*secondsInYear), since: today)
        yearsAhead = Date(timeInterval: (years*secondsInYear), since: today)
        
        let sinceYear = Calendar.current.component(.year, from: yearsAgo!)
        let toYear = Calendar.current.component(.year, from: yearsAhead!)
        
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
                monthArray.append(month)
            }
        }
    }

    func getDateIndexPath(date: Date, monthArray: [Month]) -> IndexPath {
        
        var section = 0
        var item = 0
        let startYear = monthArray[0].year
        let monthsInYear = 12
        
        if startYear < date.year {
            let yearDiff = date.year - startYear
            
            item = date.firstDayOfTheMonth.weekday + date.day - 2
            section += (yearDiff*monthsInYear) + date.month - 1
            
        } else {
            //return error
            print("error in dates")
        }
        
        let indexPath = IndexPath(item: item, section: section)
        
        return indexPath

    }
}
// get first weekday of month
extension Date {
    var weekday: Int {
        return Calendar.current.component(.weekday, from: self)
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
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

extension UIFont {
    
    //https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad
    //https://stackoverflow.com/questions/38533323/ios-swift-making-font-toggle-bold-italic-bolditalic-normal-without-change-oth
    
    var bold: UIFont {
        return with(traits: .traitBold)
    }
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    func removeBold()-> UIFont {
        if !isBold {
            return self
        } else {
            var symTraits = fontDescriptor.symbolicTraits
            symTraits.remove([.traitBold])
            let fontDescriptorVar = fontDescriptor.withSymbolicTraits(symTraits)
            return UIFont(descriptor: fontDescriptorVar!, size: 0)
        }
    }
    
    
    func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    }
}
