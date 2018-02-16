//
//  PlaidClient.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/16/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import LinkKit


class PlaidClient : NSObject {
    
    static let sharedInstance = PlaidClient()
    
    func setupPlaidLinkWithSharedConfiguration() {
        // <!-- SMARTDOWN_SETUP_SHARED -->
        // With shared configuration from Info.plist
        PLKPlaidLink.setup { (success, error) in
            if (success) {
                // Handle success here, e.g. by posting a notification
                NSLog("Plaid Link setup was successful")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PLDPlaidLinkSetupFinished"), object: self)
            }
            else if let error = error {
                NSLog("Unable to setup Plaid Link due to: \(error.localizedDescription)")
            }
            else {
                NSLog("Unable to setup Plaid Link")
            }
        }
        // <!-- SMARTDOWN_SETUP_SHARED -->
    }
    
}
