//
//  TransparentNavBar.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/21/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class TransparentNavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear

    }


}

extension UIViewController {
    
    func postSimpleAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        let dismiss = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(dismiss)
        self.present(alert, animated: true, completion: nil)
    }
        
}

