//
//  ContainerVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/19/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class ContainerVC: UIViewController {
    
    var sideMenuOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
        
    }
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    @objc func toggleSideMenu() {
        if sideMenuOpen {
            sideMenuConstraint.constant = -250
            self.view.layoutIfNeeded()
            sideMenuOpen = !sideMenuOpen
        } else {
            sideMenuConstraint.constant = 0
            self.view.layoutIfNeeded()
            sideMenuOpen = !sideMenuOpen
        }
    }
}

