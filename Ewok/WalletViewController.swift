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
    
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var mainBalance: UILabel!
    @IBOutlet weak var transactionTableView: UITableView!

    let stack = CoreDataStack.sharedInstance
    var transactions = [Transaction]()
    
    @IBAction func add(_ sender: Any) {
        let createdat = NSDate()
        let transaction = Transaction(title: "test", amount: 1220.0, income: true, createdAt: createdat, context: stack.context)
        transactions.append(transaction)
        stack.save()
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
        // Do any additional setup after loading the view, typically from a nib.
        let initialTransaction = Transaction(title: "initial", amount: 1220.0, income: true, createdAt: NSDate(), context: stack.context)
        transactions.append(initialTransaction)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        // Add predicate when wallets are set up
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Transaction>
    }
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                transactions = fc.fetchedObjects!
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
}

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as! TransactionViewCell
        let transaction = fetchedResultsController?.object(at: indexPath)
        
        cell.transDescription.text = transaction!.title
        cell.transAmount.text = String(transaction!.amount)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.short
        let convertedDate = dateFormatter.string(from: transaction!.createdAt! as Date)
    
        cell.date.text = convertedDate
        
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
