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
     var blockOperations: [BlockOperation] = []
    
    lazy var fetchedResultsController : NSFetchedResultsController<Transaction> = { () -> NSFetchedResultsController<Transaction> in
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        // Add predicate when wallets are set up
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Transaction>
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
}

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionViewCell", for: indexPath) as! TransactionViewCell
        let transaction = fetchedResultsController.object(at: indexPath)
        
        cell.transDescription.text = transaction.title
        cell.transAmount.text = String(transaction.amount)
        cell.date.text = String(describing: transaction.createdAt)
        
        return cell
    
    }
    
    
}

extension WalletViewController: NSFetchedResultsControllerDelegate {
    // MARK: FetchedResultsController Delegate Methods
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { }
    
    // Source: https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController/issues/13
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            blockOperations.append(
                BlockOperation(){ [weak self] in
                    if let block = self {
                        block.transactionTableView!.insertRows(at: [indexPath!], with: .fade)                    }
                }
            )
        case .delete:
            blockOperations.append(
                BlockOperation() { [weak self] in
                    if let block = self {
                        block.transactionTableView!.deleteRows(at: [indexPath!], with: .fade)
                    }
                }
            )
        case .update:
            blockOperations.append(
                BlockOperation() { [weak self] in
                    if let block = self {
                        block.transactionTableView!.reloadData()
                    }
                }
            )
        case .move:
            blockOperations.append(
                BlockOperation() { [weak self] in
                    if let block = self {
                        block.transactionTableView!.moveRow(at: indexPath!, to: indexPath!)
                    }
                }
            )
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        let batchUpdates = {() -> Void in
            for operation in self.blockOperations {
                operation.start()
            }
        }
        transactionTableView.performBatchUpdates(batchUpdates) { (finished) -> Void in
            self.blockOperations.removeAll()
        }
    }
}

