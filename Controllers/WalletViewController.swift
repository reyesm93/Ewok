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
    
    let stack = CoreDataStack.sharedInstance
    var wallet : Wallet?
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

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let objectCount = (fetchedResultsController?.fetchedObjects?.count)!
        let rowCount = ( objectCount == 0 ) ? 1 : objectCount
        let sectionCount = tableView.numberOfSections
        return objectCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as! TransactionViewCell
        let transaction = fetchedResultsController?.object(at: indexPath)
        cell.textLabel?.text = transaction?.description
        return cell
    
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
