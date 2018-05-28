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
    
    override func viewDidLoad() {
        tableView.register(UINib(nibName: "ProfileHeaderCell", bundle: nil), forCellReuseIdentifier: "ProfileHeaderCell")
        tableView.register(UINib(nibName: "SideMenuCell", bundle: nil), forCellReuseIdentifier: "SideMenuCell")
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func logOut(_ sender: Any) {
        
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
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        present(controller, animated: true, completion: nil)
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
        case 1: break
            //wallet,tags,
        case 2: break
            //logout
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
                sectionCell.sectionCellLabel?.text = "Wallet"
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
