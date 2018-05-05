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
    
    @IBOutlet weak var calendarView: CalendarView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todayIndexPath = calendarData.todayIndexPath
        limitsIndexPath = getTransactionIndexLimits(getTransactionsDateLimits())
        setUpView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

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
    
    
    @IBAction func completeDate(_ sender: Any) {
        
        var dates = [Date]()
        if selectedDateRange.count > 1 {
            dates.append(calendarData.getDate(fromIndex: selectedDateRange.first!))
            dates.append(calendarData.getDate(fromIndex: selectedDateRange.last!))
        } else {
            //range not wide enough alert
        }
        
        performUIUpdatesOnMain {
            self.parentVC?.updatePrededicates()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
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
    
    func getTransactionsDateLimits() -> [Date] {
        var firstDate = Date()
        var lastDate = Date()
        let sortedTransactions = parentVC?.fetchedResultsController?.fetchedObjects
        
        if (sortedTransactions?.isEmpty)! {
            //show alertview error
        } else {
            firstDate = (sortedTransactions![0].createdAt as Date?)!
            
            if (sortedTransactions?.count)! > 1 {
                lastDate = (sortedTransactions![(sortedTransactions?.count)!-1].createdAt as Date?)!
            }
        }
        
        return [lastDate, firstDate]
    }
    
    
    public func createPredicateWithDates(dates: [Date]) -> NSPredicate {
        
        return NSPredicate(format: "createdAt >= %@ && createdAt <= %@", argumentArray: [dates[0], dates[1]])
        
    }
}


