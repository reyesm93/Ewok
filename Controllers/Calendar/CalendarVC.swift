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
    var currentMonthIndex: Int = 0
    var currentYear: Int = 0
    var presentMonthIndex = 0
    var presentYear = 0
    var todaysDate = 0
    var firstWeekDayOfMonth = 0   //(Sunday-Saturday 1-7)
    var startFilter: IndexPath?
    var endFilter: IndexPath?
    var dateLimits : [Date]?
    var highlightArray = [IndexPath]()
    let calendarData = CalendarModel()
    
    @IBOutlet weak var calendarView: CalendarView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    func setUpView() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.layoutIfNeeded()
        
        calendarView.myCollectionView.delegate = self
        calendarView.myCollectionView.dataSource = self
        calendarView.myCollectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        calendarView.myCollectionView.register(MonthHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "MonthHeader")
        
        dateLimits = getTransactionsDateLimits()
        
        currentMonthIndex = Calendar.current.component(.month, from: Date())
        currentYear = Calendar.current.component(.year, from: Date())
        todaysDate = Calendar.current.component(.day, from: Date())
        
        presentMonthIndex=currentMonthIndex
        presentYear=currentYear
        

        
    }
    @IBAction func completeDate(_ sender: Any) {
        
        
    }
    
    @IBAction func cancelDate(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        print("firstDate : \(firstDate)")
        print("lastDate : \(lastDate)")
        
        return [firstDate, lastDate]
    }


}


