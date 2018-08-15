//
//  FetchControllerDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/8/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import CoreData

extension WalletVC: NSFetchedResultsControllerDelegate {
    
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
            
            //            if indexPath?.compare(newIndexPath!) == ComparisonResult.orderedDescending {
            //                updateBalances(fromIndex: newIndexPath!)
            //            } else {
            //                updateBalances(fromIndex: indexPath!)
            //            }
            
            
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        transactionTableView.endUpdates()
        
        getTransactionDateLimits()
        performUIUpdatesOnMain {
            self.updateMainBalance()
            //            self.mainBalance.text = self.wallet?.balance.currency
            //            self.mainBalance.setNeedsDisplay()
        }
        
        
    }
}
