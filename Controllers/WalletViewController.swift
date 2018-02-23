//
//  ViewController.swift
//  Ewok
//
//  Created by Arturo Reyes on 12/28/17.
//  Copyright © 2017 Arturo Reyes. All rights reserved.
//

import UIKit
import CoreData

class WalletViewController: UIViewController {
    
    @IBOutlet weak var mainBalance: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!
    @IBOutlet weak var addButton: AddButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var customBalanceView: CustomBalanceView!
    
    let stack = CoreDataStack.sharedInstance
    var wallet : Wallet?
    var scrollPosition: CGFloat?
    var currentBalance: Float!
//        didSet {
//            balanceLabel.text = String(currentBalance)
//        }
//    }
    
    @IBAction func addTransaction(_ sender: Any) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "AddTransactionViewController") as! AddTransactionViewController
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
        
    }
    
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

    init(fetchedResultsController fc : NSFetchedResultsController<Transaction>) {
        fetchedResultsController = fc
        super.init(nibName: nil, bundle: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        transactionTableView.delegate = self
        transactionTableView.dataSource = self
        mainScrollView.delegate = self
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "wallet = %@", argumentArray: [wallet!])
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Transaction>
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if executeSearch().isEmpty {
            mainScrollView.isHidden = true
        } else {
            mainScrollView.isHidden = false
            transactionTableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTransactionSegue" {
            let destination = segue.destination as! AddTransactionViewController
        }
    }
    
}

extension WalletViewController : UIScrollViewDelegate {
    
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

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
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
        return cell
    
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            self.stack.context.performAndWait {
                let deleteTransaction = self.fetchedResultsController?.object(at: indexPath)
                self.fetchedResultsController?.managedObjectContext.delete(deleteTransaction!)
            }
            completion(true)
        }
        
        deleteAction.backgroundColor = .red
        deleteAction.title = "Delete"
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
 
}

extension WalletViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        transactionTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        let set = IndexSet(integer: sectionIndex)
        
        switch (type) {
        case .insert:
            transactionTableView.insertSections(set, with: .fade)
        case .delete:
            transactionTableView.deleteSections(set, with: .fade)
        default:
            // irrelevant in our case
            break
        }
    }
    

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch(type) {
        case .insert:
            transactionTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            transactionTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            transactionTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            transactionTableView.deleteRows(at: [indexPath!], with: .fade)
            transactionTableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        transactionTableView.endUpdates()
    }
}

extension WalletViewController : AddViewControllerDelegate {
    
    func addVC(controller: UIViewController, didCreateObject: NSManagedObject) {
        stack.context.performAndWait {
            let transaction = didCreateObject as! Transaction
            transaction.wallet = self.wallet
            stack.save()
        }
    }
}
