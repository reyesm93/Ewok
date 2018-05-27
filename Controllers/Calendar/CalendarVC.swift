//
//  CalendarVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/17/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class CalendarVC : UIViewController {
    
    var parentVC: WalletVC?
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var startFilter: IndexPath?
    var endFilter: IndexPath?
    var todayIndexPath : IndexPath?
    var dateLimits : [Date]?
    var limitsIndexPath : [IndexPath]?
    let calendarData = CalendarModel()
    var selectedDateRange = [IndexPath]()
    var filtersDelegate: FiltersDelegate?
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var completeDateButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayIndexPath = calendarData.todayIndexPath
        
        if let dateLimits = parentVC?.calendarDateLimits {
            limitsIndexPath = getTransactionIndexLimits(dateLimits)
        }
        
        setUpView()
        
        completeDateButton.addTarget(self, action: #selector(didTapCompleteDate(sender:)), for: .touchUpInside)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    // Need to clear any filters so that the date range in the calendar covers all the exisiting transactions in wallet
//    func clearFilteredPredicates() {
//        if let walletVC = parentVC {
//            walletVC.cachePredicates = walletVC.predicates
//            walletVC.updatePredicates()
//
//        }
//
//    }
    
    @objc func didTapCompleteDate(sender: UIButton) {
        var dates = [Date]()
        if selectedDateRange.count > 1 {
            dates.append(calendarData.getDate(fromIndex: selectedDateRange.first!))
            dates.append(calendarData.getDate(fromIndex: selectedDateRange.last!))
        } else {
            //range not wide enough alert
        }
        
        var userInfo = [String:Any]()
        userInfo["dates"] = dates
        userInfo["filterType"] = Filters.dates
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ApplyDateFilter"), object: nil, userInfo: userInfo)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.layoutIfNeeded()
        
        calendarView.scrollTo = todayIndexPath
        calendarView.myCollectionView.delegate = self
        calendarView.myCollectionView.dataSource = self
        calendarView.myCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        calendarView.myCollectionView.register(MonthHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MonthHeader")
        calendarView.myCollectionView.scrollToItem(at: todayIndexPath!, at: .centeredVertically, animated: false)

//        if let attributes = calendarView.myCollectionView.collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath(item: 0, section: (todayIndexPath?.section)!)) {
//            let yOrigin = attributes.frame.origin.y
//            let top = calendarView.myCollectionView.contentInset.top
//            calendarView.myCollectionView.setContentOffset(CGPoint(x: 0, y: yOrigin - top), animated: true)
//        }
    }
    
    
//    @IBAction func completeDate(_ sender: Any) {
//
//        var dates = [Date]()
//        if selectedDateRange.count > 1 {
//            dates.append(calendarData.getDate(fromIndex: selectedDateRange.first!))
//            dates.append(calendarData.getDate(fromIndex: selectedDateRange.last!))
//        } else {
//            //range not wide enough alert
//        }
//
//        performUIUpdatesOnMain {
//            self.filtersDelegate?.applyFilter(controller: self, filterType: Filters.dates, filterArgument: dates)
//        }
//
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func cancelDate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getTransactionIndexLimits(_ limits : [Date]) -> [IndexPath] {
        var indexes = [IndexPath]()
        for date in limits {
            let index = calendarData.getIndexPath(fromDate: date)
            indexes.append(index)
        }
        return indexes
    }
    
//    func getTransactionsDateLimits() -> [Date] {
//        var firstDate = Date()
//        var lastDate = Date()
//        let sortedTransactions = parentVC?.fetchedResultsController?.fetchedObjects
//
//        if (sortedTransactions?.isEmpty)! {
//            //show alertview error
//        } else {
//            firstDate = (sortedTransactions![0].createdAt as Date?)!
//
//            if (sortedTransactions?.count)! > 1 {
//                lastDate = (sortedTransactions![(sortedTransactions?.count)!-1].createdAt as Date?)!
//            }
//        }
//
//        return [lastDate, firstDate]
//    }

}


