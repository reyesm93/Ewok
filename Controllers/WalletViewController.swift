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
    @IBOutlet weak var balanceLabel: UILabel!
    
    let stack = CoreDataStack.sharedInstance
    var transactions = [Transaction]()
    var wallet : Wallet?
    var user: User?
    var currentBalance: Float! {
        didSet {
            balanceLabel.text = String(currentBalance)
        }
    }
    
    @IBAction func add(_ sender: Any) {
        

        
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
        
        user = User(firstName: "Arturo", lastName: "Reyes", email: "reyesm93@gmail.com", createdAt: NSDate(), context: stack.context)
        wallet = Wallet(walletName: "TestWallet", balance: 0.0, createdAt: NSDate(), context: stack.context)
        wallet?.users = user
        stack.save()
        
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Transaction")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "wallet = %@", argumentArray: [wallet!])
    
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Transaction>
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        executeSearch()
        self.transactionTableView.reloadData()
    }
    
    func executeSearch() {
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                transactions = fc.fetchedObjects!
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addTransactionSegue" {
            let destination = segue.destination as! AddTransactionViewController
            destination.wallet = self.wallet!
        }
    }
    
}

extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchedResultsController?.fetchedObjects?.count)!
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
