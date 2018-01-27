//
//  LoginVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/19/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInUIDelegate {
    
    var user: AnyObject?
 
    @IBOutlet weak var googleSignInView: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        
        if Auth.auth().currentUser != nil {
            
            user = Auth.auth().currentUser
            DatabaseManager.sharedInstance.addUser()
            
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
            present(controller, animated: true, completion: nil)
        }
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if user != nil {
            print(Auth.auth().currentUser?.email!)
            let controller = self.storyboard!.instantiateViewController(withIdentifier: "ContainerVC") as! ContainerVC
            present(controller, animated: true, completion: nil)
        }
    
    }


}
