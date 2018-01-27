//
//  DatabaseManager.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/26/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class DatabaseManager: NSObject {
    
    static let sharedInstance = DatabaseManager()
    
    let user = Auth.auth().currentUser
    let ref = Database.database().reference()
    
    func addUser() {
        
        let id = user!.uid
        let email = user!.email
        let name = user!.displayName
    
        ref.child("users").child(id).setValue(["email": email, "name": name])
    }
    
}
