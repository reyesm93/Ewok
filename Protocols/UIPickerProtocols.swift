//
//  UIPickerDataSource.swift
//  Ewok
//
//  Created by Arturo Reyes on 8/6/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

protocol PickerDidSelectDelegate {
    func pickerDidSelect(frequencyInfo: FrequencyInfoCopy)
}
class MonthDayPickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectionDelegate: PickerDidSelectDelegate?
    var currentFrequency: FrequencyInfoCopy?
    
    var monthDays: [Int] = {
        var days = [Int]()
        for day in stride(from: 1, to: 31, by: 1) {
            days.append(day)
        }
        return days
    }()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return monthDays.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let pickerString = "\(monthDays[row])"
        return NSAttributedString(string: pickerString, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currentFrequency != nil {
            currentFrequency?.frequencyType = .byMonthDay
            currentFrequency?.monthDay = row + 1
            selectionDelegate?.pickerDidSelect(frequencyInfo: currentFrequency!)
        }
        
    }
}

class PeriodPickerDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var selectionDelegate: PickerDidSelectDelegate?
    var currentFrequency: FrequencyInfoCopy?
    
    var multipliers: [Int] = {
        var numbers = [Int]()
        for n in stride(from: 1, to: 31, by: 1) {
            numbers.append(n)
        }
        return numbers
    }()
    
    var periods = [PeriodType.days.description, PeriodType.weeks.description, PeriodType.months.description, PeriodType.years.description]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 4
        
        if component == 0 {
            count = multipliers.count
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        var pickerString = ""
        
        if component == 0 {
            pickerString = "\(multipliers[row])"
        } else {
            pickerString = "\(periods[row])"
        }
        return NSAttributedString(string: pickerString, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if currentFrequency != nil {
            currentFrequency?.frequencyType = .byPeriod
            
            if currentFrequency?.period == nil {
                let newPeriod = FrequencyPeriodCopy(1,.days)
                currentFrequency?.period = newPeriod
            }
            
            switch component {
            case 0:
                currentFrequency?.period?.value = row + 1
            case 1:
                currentFrequency?.period?.periodType = PeriodType(rawValue: row)!
            default:
                break
            }
            
            selectionDelegate?.pickerDidSelect(frequencyInfo: currentFrequency!)
        }
        
    }
    
}
