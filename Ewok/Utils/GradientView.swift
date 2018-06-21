//
//  GradientView.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/21/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

// Allow to change that class in storyboard - interface builder
@IBDesignable

class GradientView: UIView {
    
    override class var layerClass : AnyClass {
        get {
            return CAGradientLayer.self
        }
    }

    @IBInspectable var FirstColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    
    }
    
    @IBInspectable var SecondColor: UIColor = UIColor.clear {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondColor.cgColor]
        
    }

}
