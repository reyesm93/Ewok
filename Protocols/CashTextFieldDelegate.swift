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
    var fontSize: CGFloat?
    var fontColor: UIColor?
    
    init(fontSize: CGFloat, fontColor: UIColor) {
        self.fontSize = fontSize
        self.fontColor = fontColor
    }
    

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string)
        
        if let color = fontColor, let size = fontSize {
            textField.attributedText = newText.cashAttributedString(color: color, size: size)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text!.isEmpty {
            if let color = fontColor, let size = fontSize {
                textField.attributedText = "$0.00".cashAttributedString(color: color, size: size)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        <#code#>
//    }
}

