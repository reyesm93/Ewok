//
//  AddButton.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/31/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

class AddButton: UIButton {
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        circularButton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        circularButton()
    }
    
    private func circularButton() {
        // Shadow and Radius for Circle Button
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.masksToBounds = false
        layer.shadowRadius = 5
        layer.shadowOpacity = 1
        layer.cornerRadius = self.frame.width / 2
        setImage(UIImage(named: "icon_addpin.png"), for: .normal)
        backgroundColor = UIColor.white
        setTitleColor(.white, for: UIControlState())
    }
}
