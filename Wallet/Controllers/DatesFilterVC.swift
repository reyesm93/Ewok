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
    @IBOutlet weak var beforeOrAfterControl: UISegmentedControl!
    
    // MARK: Properties
    weak var walletController: WalletVC?
    weak var selectionDateDelegate: SelectedDatesDelegate?
    var isDateFilterApplied: Bool = false
    var dateRange : [Date]? {
        didSet {
            self.beforeOrAfterControl.isHidden = dateRange?.count != 1
            
            // Update Dates Button Title
            if dateRange != nil {
                var datesString: String = ""
                
                if let dateCount = dateRange?.count {
                    if dateCount > 1 {
                        if let fromDateString = dateRange?[0].shortFormatString, let toDateString = dateRange?[1].shortFormatString {
                             datesString = fromDateString + " - \n" + toDateString
                        }
                    } else if dateCount == 1, let singleDateString =  dateRange?[0].shortFormatString {
                        datesString = singleDateString
                    }
                }
                datesButton.setTitle(datesString, for: .normal)
                datesButton.setNeedsDisplay()

            }

        }
    }
    
    // MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datesButton.titleLabel?.lineBreakMode = .byWordWrapping
        beforeOrAfterControl.addTarget(self, action: #selector(filterWithSingleDate), for: UIControlEvents.valueChanged)
//        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter), name: NSNotification.Name(rawValue: "SendDates"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearFilter), name: NSNotification.Name(rawValue: "ClearFilter"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !isDateFilterApplied {
             dateRange = [Date().simpleFormat]
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
        
        if let calendarController = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "CalendarVC") as? CalendarVC {
            calendarController.definesPresentationContext = true
            calendarController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            calendarController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            calendarController.dateRangeType = .continuous
            calendarController.walletController = walletController
            calendarController.selectionDateDelegate = selectionDateDelegate
            calendarController.filterController = self
            self.present(calendarController, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapClearFilter(_ sender: Any) {
        
        let userInfo: [String:Any] = ["filterType" : FilterType.dates]
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClearFilter"), object: nil, userInfo: userInfo)
    }
    
    // MARK: Obj-C Messages
    
//    @objc func applyFilter(notification: Notification) {
//
//        guard let filterDates = notification.userInfo?["dates"] as! [Date]? else { return }
//        guard let shouldApplyFilter = notification.userInfo?["shouldApplyFilter"] as! Bool? else { return }
//
//        if shouldApplyFilter {
//            isDateFilterApplied = true
//            var datesString: String = ""
//
//            if let dates = filterDates as [Date]? {
//                dateRange = dates
//                if dates.count > 1 {
//                    datesString = dates[0].shortFormatString + " - \n" + dates[1].shortFormatString
//                } else if dates.count == 1 {
//                    datesString = dates[0].shortFormatString
//                }
//
//                datesButton.setTitle(datesString, for: .normal)
//                datesButton.setNeedsDisplay()
//            }
//        }
//    }
    
    @objc func clearFilter(notification: Notification) {
        
        isDateFilterApplied = false
        datesButton.setTitle(Date().simpleFormat.shortFormatString, for: .normal)

    }
    
    @objc func filterWithSingleDate(_ sender: UISegmentedControl) {
        
        guard dateRange?.count == 1 else { return }
        var afterDate: Bool?

        switch sender.selectedSegmentIndex {
        case 0:
            afterDate = false
        case 1:
            afterDate = true
        default:
            print("S")
        }
        
        selectionDateDelegate?.selectedDates(viewController: self, dates: dateRange!, rangeType: .single, afterDate: afterDate)
        
    }
}

