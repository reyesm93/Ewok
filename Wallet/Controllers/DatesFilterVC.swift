//
//  DatesFilterVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/22/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//
import UIKit

class DatesFilterVC : UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var datesButton: UIButton!
    @IBOutlet weak var clearFilterButton: UIButton!
    
    // MARK: Properties
    weak var parentVC: WalletVC?
    var dateRange : [Date]?
    var isDateFilterApplied: Bool = false
    
    // MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datesButton.titleLabel?.lineBreakMode = .byWordWrapping
        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter), name: NSNotification.Name(rawValue: "SendDates"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearFilter), name: NSNotification.Name(rawValue: "ClearFilter"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isDateFilterApplied {
            dateRange = [Date()]
            datesButton.setTitle(dateRange![0].shortFormatString, for: .normal)
        } else {
            if let dates = dateRange {
                let datesString = (dates.count > 1) ? dates[0].shortFormatString + " - \n" + dates[1].shortFormatString : dates[0].shortFormatString
                datesButton.setTitle(datesString, for: .normal)
            }
        }
        
        datesButton.setNeedsDisplay()
    }
    
    // MARK: Actions
    @IBAction func showCalendar(_ sender: Any) {
        
        if let vc = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            vc.definesPresentationContext = true
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.allowsMultipleDates = true
            vc.parentVC = parentVC
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapClearFilter(_ sender: Any) {
        
        let userInfo: [String:Any] = ["filterType" : FilterType.dates]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClearFilter"), object: nil, userInfo: userInfo)
    }
    
    // MARK: Obj-C Messages
    
    @objc func applyFilter(notification: Notification) {
        
        guard let filterDates = notification.userInfo?["dates"] as! [Date]? else { return }
        guard let shouldApplyFilter = notification.userInfo?["shouldApplyFilter"] as! Bool? else { return }
        
        if shouldApplyFilter {
            isDateFilterApplied = true
            var datesString: String = ""
            
            if let dates = filterDates as [Date]? {
                dateRange = dates
                if dates.count > 1 {
                    datesString = dates[0].shortFormatString + " - \n" + dates[1].shortFormatString
                } else if dates.count == 1 {
                    datesString = dates[0].shortFormatString
                }
                
                datesButton.setTitle(datesString, for: .normal)
                datesButton.setNeedsDisplay()
            }
        }
    }
    @objc func clearFilter(notification: Notification) {
        
        isDateFilterApplied = false
        datesButton.setTitle(Date().shortFormatString, for: .normal)

    }
    
    func setSingleDayBalances() {
        
        
    }
}

