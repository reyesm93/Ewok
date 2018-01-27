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

class SideMenuVC: UIViewController {
    
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
    
}
