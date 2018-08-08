//
//  ViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/28/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import CoreData

enum FilterType : Int {
    case dates = 0, tags, search, noFilter
}

class WalletVC: UIViewController {
    
    // MARK: - Outlets

    @IBOutlet weak var mainBalance: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var filterContainerView: FilterContainerView!
    @IBOutlet weak var earningsLabel: UILabel!
    @IBOutlet weak var expensesLabel: UILabel!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    @IBOutlet weak var earningsExpensesView: UIView!
    @IBOutlet weak var filterContainerViewHeight: NSLayoutConstraint!
    //    @IBOutlet weak var filterBySC: UISegmentedControl!
    
    // MARK: - Properties
    
    let stack = CoreDataStack.sharedInstance
    var wallet : Wallet?
    var placeholder: Transaction?
    var transactionsDelegate : SaveObjectDelegate?
    var scrollPosition: CGFloat = 0
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
    let staticFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
    var compoundPredicate : NSCompoundPredicate?
    var predicates = [NSPredicate]()
    var isFilterApplied : [Bool] = [false, false, false, true]
    var transactionsDateLimits = [Date]()
    var sortByAscendingDates = false
    
    var fetchedResultsController : NSFetchedResultsController<Transaction>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table

            fetchTransactions()
            fetchedResultsController?.delegate = self
            self.transactionTableView.dataSource = self
            transactionTableView.reloadData()
        }
    }
    
    var tagsFetchedResultsController : NSFetchedResultsController<Tag>? {
        
        didSet {
            fetchTags()
        }
        
    }
    
    var topTransaction : IndexPath? {
        didSet {
            //Update table view
            if fetchTransactions().count > 0 {
                guard let top = self.topTransaction else { return }
                performUIUpdatesOnMain {
                    self.transactionTableView.scrollToRow(at: top, at: .top, animated: true)
                    self.transactionTableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.automaticallyAdjustsScrollViewInsets = false
        
        print("childVCs WalletVC: \(self.childViewControllers)")
        
        if let filterVC = self.childViewControllers[0] as? DatesFilterVC {
            filterVC.selectionDateDelegate = self
            filterVC.walletController = self
//            filterVC.view.heightAnchor.constraint(equalToConstant: 0)
//            filterVC.datesButton.isHidden = false
        }
//        earningsExpensesView.heightAnchor.constraint(equalToConstant: 0).isActive = true
//        filterContainerViewHeight.isActive = false
//        filterContainerView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(applyFilter), name: NSNotification.Name(rawValue: "SendDates"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearFilter), name: NSNotification.Name(rawValue: "ClearFilter"), object: nil)
        
        // Set delegates and datasources
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        mainScrollView.delegate = self
        
        staticFetchRequest.predicate = NSPredicate(format: "wallet = %@", argumentArray: [wallet!])
        staticFetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
//        setFilterBySC()
        setTransactionDateLimits()
        updatePredicates(withPredicate: createPredicateWithDates([transactionsDateLimits[0], Date().simpleFormat]), filterType: .noFilter)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//      mainBalance.text = wallet?.balance.currency
        if fetchTransactions().count > 0 {
            updateMainBalance()
            
        }
        
        mainScrollView.isHidden = fetchTransactions().isEmpty

//        if fetchTransactions().isEmpty {
//            mainScrollView.isHidden = true
//        } else {
//            mainScrollView.isHidden = false
//        }
    }
    
    @IBAction func createTransaction(_ sender: Any) {
        
        if let controller = UIStoryboard(name: "Transaction", bundle: nil).instantiateViewController(withIdentifier: "TransactionDetailVC") as? TransactionDetailVC {
            controller.saveDelegate = self
            //controller.walletVC = self
            controller.isNewTransaction = true
            self.navigationController?.pushViewController(controller, animated: true)
            //self.present(controller, animated: true, completion: nil)
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
    
    func fetchTags() -> [Tag] {
        var tags = [Tag]()
        if let fc = tagsFetchedResultsController {
            do {
                try fc.performFetch()
                tags = fc.fetchedObjects!
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
        
        return tags
    }
    
//    func setFilterBySC() {
//
//        filterBySC.setTitle("Date", forSegmentAt: Filters.dates.rawValue)
//        filterBySC.setTitle("Tags", forSegmentAt: Filters.tags.rawValue)
//        filterBySC.setTitle("Search", forSegmentAt: Filters.search.rawValue)
//        filterBySC.addTarget(self, action: #selector(changeFilter), for: UIControlEvents.valueChanged)
//
//    }
    
    func setFetchRequest() {
        // create cases for different predicate arguments
        // https://stackoverflow.com/questions/8364495/nspredicate-for-finding-events-that-occur-between-a-certain-date-range
        // https://stackoverflow.com/questions/24176605/using-predicate-in-swift
        
        compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: sortByAscendingDates)]
        fetchRequest.predicate = compoundPredicate
        fetchRequest.includesPendingChanges = true
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Transaction>
    }
    
    func updatePredicates(withPredicate: NSPredicate? = nil, filterType: FilterType? = nil) {
        predicates.removeAll()
        let walletPredicate = NSPredicate(format: "wallet = %@", argumentArray: [wallet!])
        predicates.append(walletPredicate)
        
        if (withPredicate != nil) && (filterType != nil) {
            predicates.append(withPredicate!)
            isFilterApplied[(filterType?.rawValue)!] = true
        }
        
        setFetchRequest()

    }
    
    func createPredicateWithDates(_ dates: [Date]) -> NSPredicate {
        return NSPredicate(format: "date >= %@ && date <= %@", argumentArray: [dates[0], dates[1]])
    }
    
    // Assure that when called the first transaction in array is the later date
    
    func updateMainBalance(fromDate: [Date]? = nil) {


        let transactions = fetchTransactions()
        
        if transactions.count > 0 {
            let transactions = fetchTransactions()
            let lastTransaction: Transaction = sortByAscendingDates ? transactions[transactions.count-1] : transactions[0]

            
            let mainBalanceString = lastTransaction.newBalance.hasTwoDecimals ? "\(lastTransaction.newBalance)" : "\(lastTransaction.newBalance)0"
            mainBalance.attributedText = mainBalanceString.cashAttributedString(color: .blue, size: 52)

        }
        
    }

    
    // Update date limits to show in calendar for date range of existing transactions
    func setTransactionDateLimits() {
        transactionsDateLimits.removeAll()
        var firstDate : Date?
        var lastDate : Date?
        
        getUnsavedTransactions() { (success, result, errorString) in
            
            if success {
                if let transactionList = result {
                    if !transactionList.isEmpty {
                        if transactionList.count > 1 {
                            firstDate = transactionList[transactionList.count-1].date! as Date
                            self.transactionsDateLimits.append(firstDate!)
                        }
                        
                        lastDate = transactionList[0].date! as Date
                        self.transactionsDateLimits.append(lastDate!)
                        
                    }
                }
            } else {
                // handle error
            }
        }
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
     
        guard let filterDates = notification.userInfo?["dates"] as? [Date], let filterType = notification.userInfo?["filterType"] as? FilterType, let shouldApplyFilter = notification.userInfo?["shouldApplyFilter"] as? Bool else { return }
        
        if shouldApplyFilter {
            isFilterApplied[filterType.rawValue] = true
            
            switch filterType {
            case .dates:
                if filterDates.count == 2 {
                    updatePredicates(withPredicate: createPredicateWithDates(filterDates), filterType: .dates)
                    updateMainBalance()
                    // Update earnings/expenses label
                } else if filterDates.count == 1 {
                    if let filterAfterDate = notification.userInfo?["afterDate"] as? Bool {
                        sortByAscendingDates = filterAfterDate
                    }
                    setTransactionDateLimits()
                    let dates = sortByAscendingDates ? [filterDates[0], transactionsDateLimits[1]] : [transactionsDateLimits[0], filterDates[0]]
                    updatePredicates(withPredicate: createPredicateWithDates(dates), filterType: .dates)
                    updateMainBalance()
                }
            case .tags:
                print("S")
            case .search:
                print("S")
            case .noFilter:
                print("S")
            }
        }
    }
    
    @objc func clearFilter(notification: Notification) {
        
        guard let filterType = notification.userInfo?["filterType"] as! FilterType? else { return }
        
        isFilterApplied[filterType.rawValue] = false
        updatePredicates()
        updateMainBalance()
    }
}

extension WalletVC : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollPosition = scrollView.contentOffset.y
    }

//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        if scrollView.contentOffset.y < 0 {
//            UIView.animate(withDuration: 0.5, animations: {
//                scrollView.contentOffset.y = 0
//                return
//            })
//        }
//    }
    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        if scrollView.contentOffset.y < 0 {
//            UIView.animate(withDuration: 0.5, animations: {
//                scrollView.contentOffset.y = 0
//                return
//            })
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let newPosition = scrollView.contentOffset.y
//        let customViewHeight = customBalanceView.frame.height
//        let relativeFrame = view.convert(customBalanceView.frame, from: mainScrollView)
//        let subViewTop = relativeFrame.origin.y
//        let viewTop = mainScrollView.frame.origin.y


        if scrollPosition > newPosition {
            // User is dragging scrollview downwards
            
//            if newPosition < -20 {
//                performUIUpdatesOnMain {
//                    UIView.animate(withDuration: 0.5, animations: {
//                        scrollView.setContentOffset(CGPoint(x: 0, y: -20), animated: true)
//                        return
//                    })
//                }
//            }

//            if (subViewTop == viewTop) {
//                mainScrollView.isScrollEnabled = false
//            }
        } else {
            // User is dragging scrollview upwards

            let tablePosition = transactionTableView.contentOffset.y
            if tablePosition == 0 {
                mainScrollView.isScrollEnabled = true
            }
        }
    }
}

extension WalletVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objectCount = (fetchedResultsController?.fetchedObjects?.count)!
        return objectCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as! TransactionViewCell
        let transaction = fetchedResultsController?.object(at: indexPath)
        
        cell.selectionStyle = .none
        cell.descriptionLabel.text = transaction?.title
        cell.amountLabel.text = transaction?.amount.currency
        cell.dateLabel.text = (transaction!.date! as Date).shortFormatString
        cell.newBalanceLabel.text = transaction?.newBalance.currency
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let chosenTransaction = fetchedResultsController?.object(at: indexPath)
        
        if let controller = UIStoryboard(name: "Transaction", bundle: nil).instantiateViewController(withIdentifier: "TransactionDetailVC") as? TransactionDetailVC {
            controller.saveDelegate = self
            controller.walletVC = self
            controller.existingTransaction = chosenTransaction
            self.navigationController?.pushViewController(controller, animated: true)
//            controller.itemIndex = indexPath
            //self.present(controller, animated: true, completion: nil)
        }
        

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
}
    

extension WalletVC: SelectedDatesDelegate {
    func selectedDates(viewController: UIViewController, dates: [Date], rangeType: DateRangeType, afterDate:Bool?) {

        if dates.count == 2 {
            updatePredicates(withPredicate: createPredicateWithDates(dates), filterType: .dates)
            updateMainBalance()
            // Update earnings/expenses label
        } else if dates.count == 1 {
            if let isAfter = afterDate {
                sortByAscendingDates = isAfter
            }
            setTransactionDateLimits()
            let dates = sortByAscendingDates ? [dates[0], transactionsDateLimits[1]] : [transactionsDateLimits[0], dates[0]]
            updatePredicates(withPredicate: createPredicateWithDates(dates), filterType: .dates)
            updateMainBalance()
        }
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
    
    var hasTwoDecimals: Bool {
        let decimals = self.truncatingRemainder(dividingBy: 1)
        if decimals == 0 || "\(decimals)".count <= 3 {
            return false
        }
        return true
    }
}




