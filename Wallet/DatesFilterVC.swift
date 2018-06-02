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
    @IBOutlet weak var clearFilterButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datesButton.titleLabel?.lineBreakMode = .byWordWrapping
        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter), name: NSNotification.Name(rawValue: "ApplyDateFilter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearFilter), name: NSNotification.Name(rawValue: "ClearFilter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setDateBalances), name: NSNotification.Name(rawValue: "DateBalances"), object: nil)
        
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
        
        if let vc = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            vc.definesPresentationContext = true
            vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            vc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            vc.parentVC = parentVC
            self.present(vc, animated: true, completion: nil)
        }
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
    
    @IBAction func didTapClearFilter(_ sender: Any) {
        
        let userInfo: [String:Any] = ["filterType" : Filters.dates]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClearFilter"), object: nil, userInfo: userInfo)
    }
    
    @objc func clearFilter(notification: Notification) {
        
        isDateFilterApplied = false
        datesButton.setTitle(Date().formattedString, for: .normal)

    }
    
    fileprivate func calculateDateBalances() {
        var sum : Double = 0.0
        var minus : Double = 0.0
        var total : Double = 0.0
        
        if let filteredTransactions = parentVC?.fetchedResultsController?.fetchedObjects {
            if filteredTransactions.count > 0 {
                for transaction in filteredTransactions {
                    if transaction.amount > 0 {
                        sum += transaction.amount
                    } else if transaction.amount < 0 {
                        minus += transaction.amount
                    }
                }
            } else {
                // send notification and show message saying that there are not any transactions in the requested date(s)
            }
        }
        
        total = sum + minus
        
        earningsLabel.text = "\(sum.currency!)"
        expensesLabel.text = "\(minus.currency!)"
        totalBalanceLabel.text = "\(total.currency!)"
        
        earningsLabel.setNeedsDisplay()
        expensesLabel.setNeedsDisplay()
        totalBalanceLabel.setNeedsDisplay()
    }
    
    @objc func setDateBalances(notification: Notification) {
        calculateDateBalances()
    }
    
    func setSingleDayBalances() {
        
        
    }
}

