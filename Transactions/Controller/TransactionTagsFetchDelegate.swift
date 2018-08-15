//
//  TransactionTagsFetchDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/10/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

//import UIKit
//import CoreData
//
//extension TagsVC : NSFetchedResultsControllerDelegate {
//
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tagsTableView.beginUpdates()
//    }
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//
//        let set = IndexSet(integer: sectionIndex)
//
//        switch (type) {
//        case .insert:
//            tagsTableView.insertSections(set, with: .fade)
//        case .delete:
//            tagsTableView.deleteSections(set, with: .fade)
//        default:
//            // irrelevant in our case
//            break
//        }
//    }
//
//
//    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//
//        switch(type) {
//        case .insert:
//            tagsTableView.insertRows(at: [newIndexPath!], with: .fade)
//        case .delete:
//            tagsTableView.deleteRows(at: [indexPath!], with: .fade)
//        case .update:
//            tagsTableView.reloadRows(at: [indexPath!], with: .fade)
//        case .move:
//            tagsTableView.deleteRows(at: [indexPath!], with: .fade)
//            tagsTableView.insertRows(at: [newIndexPath!], with: .fade)
//
//        }
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tagsTableView.endUpdates()
//
//    }
//}
