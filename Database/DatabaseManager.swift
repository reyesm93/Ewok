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
        ref.child("users").child(user!.uid).setValue(["email": user!.email])
    }
    
}
