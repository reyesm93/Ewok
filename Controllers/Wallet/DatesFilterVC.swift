//
//  DatesFilterVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/22/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//
import UIKit

class DatesFilterVC : UIViewController {
    
    weak var parentVC: WalletVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.parentVC = parentVC
        self.present(vc, animated: true, completion: nil)
        
    }
 
}

