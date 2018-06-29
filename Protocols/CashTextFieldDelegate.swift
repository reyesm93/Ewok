//
//  CashTextFieldDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/29/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

// MARK: - CashTextFieldDelegate: NSObject, UITextFieldDelegate

class CashTextFieldDelegate: NSObject, UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var cashStringAttributes = [NSAttributedStringKey:Any]()
        cashStringAttributes[NSAttributedStringKey.foregroundColor] = UIColor.white
        cashStringAttributes[NSAttributedStringKey.font] = UIFont(name: "DINAlternate-Bold", size: 58)

        let oldText = textField.text! as NSString
        var newText = oldText.replacingCharacters(in: range, with: string)
        var newTextString = String(newText)
        var attributedText = NSMutableAttributedString()
        let dollarSign = NSAttributedString(string: "$", attributes: cashStringAttributes)
        let period = NSAttributedString(string: ".", attributes: cashStringAttributes)
        
        let digits = CharacterSet.decimalDigits
        var digitText = ""
        for c in (newTextString.unicodeScalars) {
            if digits.contains(UnicodeScalar(c.value)!) {
                digitText.append("\(c)")
            }
        }
        
        
        // Format the new string
        if let numOfPennies = Int(digitText) {
            attributedText.append(dollarSign)
            attributedText.append(dollarStringFromInt(numOfPennies, attributes: cashStringAttributes))
            attributedText.append(period)
            attributedText.append(centsStringFromInt(numOfPennies, attributes: cashStringAttributes))
        } else {
            var smallerAttribute = cashStringAttributes
            smallerAttribute[NSAttributedStringKey.font] = UIFont(name: "DINAlternate-Bold", size: 42)
            
            attributedText.append(NSAttributedString(string: "$0.", attributes: cashStringAttributes))
            attributedText.append(NSAttributedString(string: "00", attributes: smallerAttribute))
        }
        
        textField.attributedText = attributedText
        
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            textField.text = "$0.00"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func dollarStringFromInt(_ value: Int, attributes: [NSAttributedStringKey:Any]) -> NSAttributedString {
        return NSAttributedString(string: String(value / 100), attributes: attributes)
    }
    
    func centsStringFromInt(_ value: Int, attributes: [NSAttributedStringKey:Any]) -> NSAttributedString {
        
        var smallerAttribute = attributes
        smallerAttribute[NSAttributedStringKey.font] = UIFont(name: "DINAlternate-Bold", size: 24)
        
        let cents = value % 100
        var centsString = String(cents)
        
        if cents < 10 {
            centsString = "0" + centsString
        }
        
        return NSAttributedString(string: centsString, attributes: smallerAttribute)
    }
}
