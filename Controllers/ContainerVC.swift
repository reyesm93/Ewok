//
//  ContainerVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/19/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class ContainerVC: UIViewController, UIGestureRecognizerDelegate {
    
    var sideMenuOpen = false
    var coverView: UIView? = nil
    var mainNavController: UINavigationController?
    
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    @IBOutlet weak var navControllerView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("childVCs ContainerVC: \(self.childViewControllers)")
        
        for child in self.childViewControllers {
            if child is UINavigationController {
                mainNavController = child as? UINavigationController
            }
        }
        
        let navRect = navControllerView.bounds
        coverView = UIView(frame: navRect)
        //coverView!.backgroundColor = UIColor.black.withAlphaComponent(0.6)

        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
    }
    
    @objc func toggleSideMenu() {
        
        performUIUpdatesOnMain {
            
            if !(self.sideMenuOpen) {
        
                self.sideMenuConstraint.constant = 0
                self.navControllerView.addSubview(self.coverView!)
                self.view.bringSubview(toFront: self.sideMenuView)
                self.sideMenuView.layer.shadowOpacity = 1
                self.sideMenuView.layer.shadowRadius = 8
                self.sideMenuOpen = !self.sideMenuOpen
                
                let dismissTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissSideView))
                self.navControllerView.addGestureRecognizer(dismissTapRecognizer)
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
                
            } else {
                self.dismissSideView()
            }
        }
    }
    
    @objc func dismissSideView() {
        
        performUIUpdatesOnMain {
            
            if self.sideMenuOpen {
                self.coverView!.removeFromSuperview()
                self.sideMenuConstraint.constant = -260
                self.sideMenuOpen = !self.sideMenuOpen
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}

