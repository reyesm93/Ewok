//
//  MenuContainerVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/19/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit
import SnapKit
import CoreData

class MenuContainerVC: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var navControllerView: UIView!
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: UIView!
    
    // MARK: Properties
    var sideMenuOpen = false
    var coverView: UIView? = nil
    var sectionController: SectionContainerVC?
    var sideMenuController: SideMenuVC?

    // MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        setUpDelegates()

        NotificationCenter.default.addObserver(self, selector: #selector(toggleSideMenu), name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
    }
    
    // MARK: Methods
    private func setUpView() {
        navControllerView.backgroundColor = .clear
        sideMenuConstraint.constant = view.frame.width * -0.8
        
        let navRect = navControllerView.bounds
        coverView = UIView(frame: navRect)
        //coverView!.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
    private func setUpDelegates() {
        
        for child in childViewControllers {
            if let navCotroller = child as? TransparentNavController {
                if let topController = navCotroller.topViewController as? SectionContainerVC {
                    sectionController = topController
                }
            } else if child is SideMenuVC {
                sideMenuController = child as! SideMenuVC
            }
        }
        
        guard sectionController != nil else { return }
        guard sideMenuController != nil else { return }
        
        sideMenuController?.sectionDelegate = sectionController
    }
    
    // MARK: Obj-C Messages
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
                self.sideMenuConstraint.constant = -1 * self.view.frame.width * 0.8
                self.sideMenuOpen = !self.sideMenuOpen
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}

