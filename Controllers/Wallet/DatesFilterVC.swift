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
    var dateRange : [Date]?
    var isDateFilterApplied: Bool = false
    
 
    @IBOutlet weak var datesButton: UIButton!
    @IBOutlet weak var earningsTextLabel: UILabel!
    @IBOutlet weak var earningsLabel: UILabel!
    @IBOutlet weak var expensesTextLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var totalBalanceTextLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter), name: NSNotification.Name(rawValue: "ApplyDateFilter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearFilter), name: NSNotification.Name(rawValue: "ClearFilter"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isDateFilterApplied {
            dateRange = [Date()]
            datesButton.setTitle(dateRange![0].formattedString, for: .normal)
        } else {
            if let dates = dateRange {
                let datesString = (dates.count > 1) ? dates[0].formattedString + " - \n" + dates[1].formattedString : dates[0].formattedString
                datesButton.setTitle(datesString, for: .normal)
            }
        }
        
        datesButton.setNeedsDisplay()
    }
    
    @IBAction func showCalendar(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "CalendarVC") as! CalendarVC
        vc.definesPresentationContext = true
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        vc.parentVC = parentVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    @objc func applyFilter(notification: Notification) {
        
        guard let filterDates = notification.userInfo?["dates"] as! [Date]? else { return }
        
        isDateFilterApplied = true
        var datesString: String = ""
        
        if let dates = filterDates as [Date]? {
            dateRange = dates
            if dates.count > 1 {
                datesString = dates[0].formattedString + " - \n" + dates[1].formattedString
            } else if dates.count == 1 {
                datesString = dates[0].formattedString
            }
            
            datesButton.setTitle(datesString, for: .normal)
            datesButton.setNeedsDisplay()
        }

    }
    
    @objc func clearFilter(notification: Notification) {
        
        isDateFilterApplied = false
        datesButton.setTitle(Date().formattedString, for: .normal)

    }
    
    func setDateBalances() {
        
    }
}

