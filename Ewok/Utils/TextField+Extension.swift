//
//  TextField+Extension.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/30/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    func cashAttributedString(color: UIColor, size: CGFloat) -> NSAttributedString {
        
        let isNegative = self.hasPrefix("-")
        let attributedText = NSMutableAttributedString()
        var cashStringAttributes = [NSAttributedString.Key:Any]()
        cashStringAttributes[NSAttributedString.Key.foregroundColor] = isNegative ? UIColor.red : color
        cashStringAttributes[NSAttributedString.Key.font] = UIFont(name: "KohinoorBangla-Light", size: size)
        
        var centStringAttributes = cashStringAttributes
        centStringAttributes[NSAttributedString.Key.font] = UIFont(name: "KohinoorBangla-Light", size: round((size*0.7)))
        
        let dollarSign = NSAttributedString(string: "$", attributes: centStringAttributes)
        let period = NSAttributedString(string: ".", attributes: cashStringAttributes)
        let negativeSign = NSAttributedString(string: "-", attributes: centStringAttributes)
        
        let digits = CharacterSet.decimalDigits
        var digitText = ""
        for c in (self.unicodeScalars) {
            if digits.contains(UnicodeScalar(c.value)!) {
                digitText.append("\(c)")
            }
        }
        
        // Format the new string
        if let numOfPennies = Int(digitText) {
            if isNegative {
                attributedText.append(negativeSign)
            }
            attributedText.append(dollarSign)
            attributedText.append(dollarStringFromInt(numOfPennies, attributes: cashStringAttributes))
            attributedText.append(period)
            attributedText.append(centsStringFromInt(numOfPennies, attributes: centStringAttributes))
        } else {
            attributedText.append(dollarSign)
            attributedText.append(NSAttributedString(string: "0.00", attributes: cashStringAttributes))
        }
        
        
        return attributedText
    }
    
    func dollarStringFromInt(_ value: Int, attributes: [NSAttributedString.Key:Any]) -> NSAttributedString {
        return NSAttributedString(string: String(value / 100), attributes: attributes)
    }
    
    func centsStringFromInt(_ value: Int, attributes: [NSAttributedString.Key:Any]) -> NSAttributedString {
        
        let cents = value % 100
        var centsString = String(cents)
        
        if cents < 10 {
            centsString = "0" + centsString
        }
        
        return NSAttributedString(string: centsString, attributes: attributes)
    }
    
    func convertCurrencytoDouble() -> Double? {
        var copy = self
        var isNegative = false
        
        if copy.hasPrefix("-") {
            isNegative = true
            copy.removeFirst()
        }
        
        if copy.hasPrefix("$") {
            copy.removeFirst()
        }
        
        if let doubleType = Double(copy) {
            return isNegative ? doubleType * -1.0 : doubleType
        }
        
        return nil
    }
}

extension UITextField {
    
    func addDoneButtonOnKeyboard() {
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(doneButtonAction(sender:)))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
        
    }
    
    @objc func doneButtonAction(sender: UIBarButtonItem) {
        self.resignFirstResponder()
    }
    
}
