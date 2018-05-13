//
//  ViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/28/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import CoreData

enum Filters : Int {
    case dates = 0, tags, search
}

class WalletVC: UIViewController {

    @IBOutlet weak var mainBalance: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var customBalanceView: CustomBalanceView!
    @IBOutlet weak var filterContainerView: FilterContainerView!
    @IBOutlet weak var filterBySC: UISegmentedControl!
    
    
    let stack = CoreDataStack.sharedInstance
    var wallet : Wallet?
    var placeholder: Transaction?
    var transactionsDelegate : UpdateTransactionsDelegate?
    var scrollPosition: CGFloat?
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
    var compoundPredicate : NSCompoundPredicate?
    var predicates = [NSPredicate]()
    var isFilterApplied : [Bool] = [false, false, false]
    
    var fetchedResultsController : NSFetchedResultsController<Transaction>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            fetchTransactions()
            self.transactionTableView.dataSource = self
            transactionTableView.reloadData()
        }
    }
    
    var topTransaction : IndexPath? {
        didSet {
            //update table view
            performUIUpdatesOnMain {
                self.transactionTableView.scrollToRow(at: self.topTransaction!, at: .top, animated: true)
                self.transactionTableView.reloadData()
            }
            
        }
    }
    
    // MARK: Initializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    init(fetchedResultsController fc : NSFetchedResultsController<Transaction>) {
//        fetchedResultsController = fc
//        super.init(nibName: nil, bundle: nil)
//    }
    
    @IBAction func createTransaction(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionVC
        controller.saveDelegate = self
        controller.walletVC = self
        self.present(controller, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
         self.automaticallyAdjustsScrollViewInsets = false
        
        print("childVCs WalletVC: \(self.childViewControllers)")
        
        if let filterVC = self.childViewControllers[0] as? DatesFilterVC {
            filterVC.parentVC = self
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter), name: NSNotification.Name(rawValue: "ApplyDateFilter"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearFilter), name: NSNotification.Name(rawValue: "ClearFilter"), object: nil)
        
        // Set delegates and datasources
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        mainScrollView.delegate = self
        
        customBalanceView.wallet = wallet
        
        topTransaction = setTopTransaction(fromDate: [Date()])
        
        setFilterBySC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainBalance.text = wallet?.balance.currency
        
        if fetchTransactions().isEmpty {
            mainScrollView.isHidden = true
        } else {
            mainScrollView.isHidden = false
        }
    }
    
    func fetchTransactions() -> [Transaction] {
        var transactions = [Transaction]()
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                transactions = fc.fetchedObjects!
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
        
        return transactions
    }
    
    func setFilterBySC() {
        
        filterBySC.setTitle("Date", forSegmentAt: Filters.dates.rawValue)
        filterBySC.setTitle("Tags", forSegmentAt: Filters.tags.rawValue)
        filterBySC.setTitle("Search", forSegmentAt: Filters.search.rawValue)
        filterBySC.addTarget(self, action: #selector(changeFilter), for: UIControlEvents.valueChanged)
        
    }
    
    func setFetchRequest() {
        // create cases for different predicate arguments
        // https://stackoverflow.com/questions/8364495/nspredicate-for-finding-events-that-occur-between-a-certain-date-range
        // https://stackoverflow.com/questions/24176605/using-predicate-in-swift
        
        compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.predicate = compoundPredicate
        fetchRequest.includesPendingChanges = true
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Transaction>
    }
    
    func updatePredicates(withPredicate: NSPredicate? = nil, filterType: Filters? = nil) {
        predicates.removeAll()
        let walletPredicate = NSPredicate(format: "wallet = %@", argumentArray: [wallet!])
        predicates.append(walletPredicate)
        
        if (withPredicate != nil) && (filterType != nil) {
            predicates.append(withPredicate!)
            isFilterApplied[(filterType?.rawValue)!] = true
        }
        
        setFetchRequest()

    }
    
    // Assure that when called the first transaction in array is the later date
    func setTopTransaction(fromDate: [Date]) -> IndexPath {
        
        // Need to assure that predicate is set for all existing transactions so
        // that the fetch returns all
        updatePredicates()
        
        let date = fromDate[0]
        let transactions = fetchTransactions()
        var count : Int = 0
        var scrollTo: Transaction? = transactions[count]
        var scrollToIndexPath: IndexPath?
        
        
        while (scrollTo?.createdAt! as! Date) > date && count < transactions.count {
            
            // consider scenario where it's the same day but later
            
            scrollTo = transactions[count]
            count += 1
        }
        
        scrollToIndexPath = IndexPath(item: (transactions.index(of: scrollTo!))!, section: 0)
        return scrollToIndexPath!
        
    }
    
    func scrollToTransaction() {
        
    }
    
    @objc func changeFilter(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            print("date")
        case 1:
            print("tag")
        case 2:
            print("search")
        default:
            break
        }
    }
    
    @objc func applyFilter(notification: Notification) {
        
        guard let filterDates = notification.userInfo?["dates"] as! [Date]? else { return }
        guard let filterType = notification.userInfo?["filterType"] as! Filters? else { return }
        
        isFilterApplied[filterType.rawValue] = true
        
        switch filterType {
        case .dates:
            if let dates = filterDates as [Date]? {
                updatePredicates(withPredicate: createPredicateWithDates(dates), filterType: .dates)
            }
        case .tags:
            print("S")
        case .search:
            print("S")
        }
    
    }
    
    @objc func clearFilter(notification: Notification) {
        updatePredicates()
    }
}

extension WalletVC : UIScrollViewDelegate {
    
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//        scrollPosition = scrollView.contentOffset.y
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let newPosition = scrollView.contentOffset.y
//        let customViewHeight = customBalanceView.frame.height
//        let relativeFrame = view.convert(customBalanceView.frame, from: mainScrollView)
//        let subViewTop = relativeFrame.origin.y
//        let viewTop = mainScrollView.frame.origin.y
//
//
//        if scrollPosition! < newPosition {
//            // User is dragging scrollview downwards
//
//            if (subViewTop == viewTop) {
//                mainScrollView.isScrollEnabled = false
//            }
//        } else {
//            // User is dragging scrollview upwards
//
//            let tablePosition = transactionTableView.contentOffset.y
//            if tablePosition == 0 {
//                mainScrollView.isScrollEnabled = true
//            }
//        }
//    }
}

extension WalletVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objectCount = (fetchedResultsController?.fetchedObjects?.count)!
        return objectCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as! TransactionViewCell
        let transaction = fetchedResultsController?.object(at: indexPath)
        
        
        cell.descriptionLabel.text = transaction?.title
        cell.amountLabel.text = transaction?.amount.currency
        cell.dateLabel.text = (transaction!.createdAt! as Date).formattedString
        cell.newBalanceLabel.text = transaction?.newBalance.currency
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let transaction = fetchedResultsController?.object(at: indexPath)
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionVC
        controller.saveDelegate = self
        controller.walletVC = self
        controller.transaction = transaction
        controller.itemIndex = indexPath
        self.present(controller, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            self.deleteTransation(indexPath: indexPath) { (success, error) in
                if success {
                    completion(true)
                } else {
                    print(error)
                }
            }
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.title = "Delete"
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func createPredicateWithDates(_ dates: [Date]) -> NSPredicate {
        return NSPredicate(format: "createdAt >= %@ && createdAt <= %@", argumentArray: [dates[0], dates[1]])
    }
 
}

extension Double {
    
    static var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter
    }()
    
    var currency: String? {
        return Double.currencyFormatter.string(from: self as NSNumber)
    }
}




