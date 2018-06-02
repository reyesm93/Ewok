//
//  TagsTableVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 5/31/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TagsVC : UIViewController {
    
    
    // MARK: - Properties
    let stack = CoreDataStack.sharedInstance
    var tagsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
    
    var fetchedResultsController : NSFetchedResultsController<Transaction>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            
//            fetchTags()
            fetchedResultsController?.delegate = self
//            self.transactionTableView.dataSource = self
//            transactionTableView.reloadData()
        }
    }
    
    // MARK: - Initializer Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFetchRequest()
        
    }
    
    
    // MARK: - Methods
    
    func setFetchRequest() {
    
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: tagsFetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Transaction>
    }
//
//    func fetchTags() -> [Tag] {
//
//
//    }
    
}

extension TagsVC : CreateObjectDelegate {
    func createNewObject(controller: UIViewController, saveObject: NSManagedObject, isNew: Bool) {
        // to perform when a Tag is added
    }
    
    
    
}
