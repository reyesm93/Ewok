//
//  AddButton.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/31/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

class CircularButton: UIButton {
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
        titleLabel?.removeFromSuperview()
        layer.masksToBounds = false
        layer.cornerRadius = self.frame.width / 2
        contentMode = .center
        imageView?.contentMode = .scaleAspectFit
    }
}

class AddButton: CircularButton {
    
    // MARK: Initialization
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    private func setView() {
        // Shadow and Radius for Circle Button
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.8
        backgroundColor = UIColor.white
        titleLabel?.removeFromSuperview()
        setImage(UIImage(named: "icon_addpin.png"), for: .normal)
        imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

class FilterTypeButton : CircularButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    private func setView() {
        layer.borderWidth = 1
        backgroundColor = .clear
        imageEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
