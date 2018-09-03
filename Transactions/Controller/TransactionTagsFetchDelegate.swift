//
//  TransactionTagsFetchDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/10/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit
import CoreData

extension TransactionDetailVC : NSFetchedResultsControllerDelegate {
    
    func fetchTags() -> [Tag] {
        var tags = [Tag]()
        if let fc = tagsFetchedResultsController {
            do {
                try fc.performFetch()
                tags = fc.fetchedObjects!
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: tagsFetchedResultsController))")
            }
        }
        
        return tags
    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        detailsTableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        var newTagIndexPath: IndexPath?
        var tagIndexPath: IndexPath?
        
        if let new = newIndexPath {
            newTagIndexPath = IndexPath(row: new.row, section: 1)
        }
        
        if let index = indexPath {
            tagIndexPath = IndexPath(row: index.row, section: 1)
        }
        

        switch(type) {
        case .insert:
            detailsTableView.insertRows(at: [newTagIndexPath!], with: .fade)
        case .delete:
            detailsTableView.deleteRows(at: [tagIndexPath!], with: .fade)
        case .update:
            detailsTableView.reloadRows(at: [tagIndexPath!], with: .fade)
        case .move:
            detailsTableView.deleteRows(at: [tagIndexPath!], with: .fade)
            detailsTableView.insertRows(at: [newTagIndexPath!], with: .fade)

        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        detailsTableView.endUpdates()

    }
}
