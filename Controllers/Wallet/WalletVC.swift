//
//  ViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/28/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import CoreData

class WalletVC: UIViewController {

    @IBOutlet weak var mainBalance: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var customBalanceView: CustomBalanceView!
    @IBOutlet weak var filterContainerView: FilterContainerView!
    
    
    let stack = CoreDataStack.sharedInstance
    var wallet : Wallet?
    var placeholder: Transaction?
    var scrollPosition: CGFloat?
    var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
    var fetchedResultsController : NSFetchedResultsController<Transaction>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchedResultsController?.delegate = self
            executeSearch()
            self.transactionTableView.dataSource = self
            transactionTableView.reloadData()
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
    
    @IBAction func addTransaction(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionVC
        controller.saveDelegate = self
        controller.walletVC = self
        self.present(controller, animated: true, completion: nil)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("childVCs WalletVC: \(self.childViewControllers)")
        
        if let filterVC = self.childViewControllers[0] as? DatesFilterVC {
            filterVC.parentVC = self
        }
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        mainScrollView.delegate = self
        
        customBalanceView.wallet = wallet
        
        // create cases for different predicate arguments
        // https://stackoverflow.com/questions/8364495/nspredicate-for-finding-events-that-occur-between-a-certain-date-range
        // https://stackoverflow.com/questions/24176605/using-predicate-in-swift
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "wallet = %@", argumentArray: [wallet!])
        fetchRequest.includesPendingChanges = true
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Transaction>
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainBalance.text = "\((wallet?.balance)!)"
        
        if executeSearch().isEmpty {
            mainScrollView.isHidden = true
        } else {
            mainScrollView.isHidden = false
        }
    }
    
    func executeSearch() -> [Transaction] {
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
        let sectionCount = tableView.numberOfSections
        return objectCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as! TransactionViewCell
        let transaction = fetchedResultsController?.object(at: indexPath)
        
        
        cell.descriptionLabel.text = transaction?.title
        cell.amountLabel.text = String(describing: (transaction?.amount)!)
        cell.dateLabel.text = makeDate(fromTransaction: transaction!)
        cell.newBalanceLabel.text = String(describing: (transaction?.newBalance)!)
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
    
    func makeDate(fromTransaction: Transaction) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        
        let date = dateFormatter.string(from: fromTransaction.createdAt! as Date).uppercased()
        
        return date
        
    }
 
}


