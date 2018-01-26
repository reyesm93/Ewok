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
    //var navController: UINavigationController?
    //var sideMenuVC: SideMenuVC?
    
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //guard let nav = childViewControllers.first as? UINavigationController else {
            //fatalError("Check storyboard for missing NavigationController")
        //}
        
        //guard let sideMenu = childViewControllers.first as? SideMenuVC else {
            //fatalError("Check storyboard for missing SideMenuVC")
        //}
        
        //navController = nav
        //sideMenuVC = sideMenu
        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
        
    }
    
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

