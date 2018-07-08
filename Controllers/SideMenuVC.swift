//
//  SideMenuVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/27/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase

class SideMenuVC: UITableViewController {
    
    let appDelegate = UIApplication.shared.delegate
    var sectionDelegate: SelectedSectionDelegate? = nil
    
    override func viewDidLoad() {
    
        tableView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderCell")
        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        tableView.isScrollEnabled = false
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    func logOut() {
        
        GIDSignIn.sharedInstance().signOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        userDidLogOut()
        
    }
    
    func userDidLogOut() {
        
        let initialViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        appDelegate?.window??.rootViewController = initialViewController
        appDelegate?.window??.makeKeyAndVisible()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return 1
        default:
            break
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        
        switch section {
        case 0: break
            //profile
        case 1:
            switch indexPath.row {
            case 0:
                if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
                    sectionDelegate?.selectedSection(viewController: controller)
                    showSideMenu()
                }
            case 1:
                if let controller = UIStoryboard(name: "Tags", bundle: nil).instantiateViewController(withIdentifier: "TagsVC") as? TagsVC {
                    sectionDelegate?.selectedSection(viewController: controller)
                    showSideMenu()
                }
                
            default:
                break
            }
        
        case 2:
            logOut()
        default:
            break
        }
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        
        switch section {
        case 0:
            let profileCell = tableView.dequeueReusableCell(withIdentifier: "ProfileHeaderCell") as! ProfileHeaderCell
            profileCell.userNameLabel.text = DatabaseManager.sharedInstance.user?.displayName
            profileCell.userNameLabel.lineBreakMode = .byWordWrapping
            return profileCell

        case 1:
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath) as! SideMenuCell
            switch indexPath.row {
            case 0:
                sectionCell.sectionCellLabel?.text = "Home"
                return sectionCell
            case 1:
                sectionCell.sectionCellLabel?.text = "Tags"
                return sectionCell
            default:
                break
            }
        case 2:
            let sectionCell = tableView.dequeueReusableCell(withIdentifier: "SideMenuCell", for: indexPath)  as! SideMenuCell
            sectionCell.sectionCellLabel?.text = "Logout"
            return sectionCell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    
}
