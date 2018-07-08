//
//  FlowPresentationManager.swift
//  Ewok
//
//  Created by Arturo Reyes on 7/7/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

enum FlowPresentationStyle {
    case push, modal
}

class FlowPresentationManager {
    
    static let sharedManager = FlowPresentationManager()
    
    public func performPresentation(_ viewController: UIViewController, style: FlowPresentationStyle) {
        
        let appDelegate = UIApplication.shared.delegate
        
        switch style {
            
        case .push:
            if let rootNavController = appDelegate?.window??.rootViewController as? UINavigationController {
                rootNavController.pushViewController(viewController, animated: true)
            }
        case .modal:
            print("")
        }
    }
    
}
