//
//  CalendarVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/17/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

enum DateRangeType: Int {
    case single = 0, continuous, specific
}

class CalendarVC : UIViewController {
    
    // MARK: Outelts
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var completeDateButton: UIButton!
    
    //MARK: Properties
    weak var walletController: WalletVC?
    weak var filterController: DatesFilterVC?
    weak var selectionDateDelegate: SelectedDatesDelegate?
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var startDate: IndexPath?
    var endDate: IndexPath?
    var todayIndexPath : IndexPath?
    var dateLimits : [Date]?
    var limitsIndexPath : [IndexPath]?
    let calendarData = CalendarModel()
    var dateRangeType: DateRangeType?
    var selectedDateRange = [IndexPath]() {
        didSet {
            completeDateButton.isEnabled = (selectedDateRange.count > 0) ? true : false
        }
    }

    //MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        todayIndexPath = calendarData.todayIndexPath
        
        if let dateLimits = walletController?.getTransactionDateLimits() {
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
        } else if selectedDateRange.count == 1 {
            dates.append(calendarData.getDate(fromIndex: selectedDateRange[0]))
        }
        guard let dateRangeType = dateRangeType else { return }
        filterController?.dateRange = dates
        selectionDateDelegate?.selectedDates(viewController: self, dates: dates, rangeType: dateRangeType, afterDate: nil)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpView() {
        self.view.layoutIfNeeded()
        calendarView.scrollTo = todayIndexPath
        calendarView.myCollectionView.delegate = self
        calendarView.myCollectionView.dataSource = self
        calendarView.myCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        calendarView.myCollectionView.register(MonthHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MonthHeader")
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
//
//        dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func cancelDate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearDates(_ sender: Any) {
        selectedDateRange.removeAll()
        calendarView.myCollectionView.reloadData()
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
//            firstDate = (sortedTransactions![0].date as Date?)!
//
//            if (sortedTransactions?.count)! > 1 {
//                lastDate = (sortedTransactions![(sortedTransactions?.count)!-1].date as Date?)!
//            }
//        }
//
//        return [lastDate, firstDate]
//    }

}


