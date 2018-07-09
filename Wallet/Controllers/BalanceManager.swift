//
//  BalanceManager.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/2/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension WalletVC: SaveObjectDelegate {
    
    func saveObject(controller: UIViewController, saveObject: NSManagedObject, isNew: Bool) {
        
        let transaction = saveObject as! Transaction
        
        if isNew {
            transaction.wallet = self.wallet
        }
        
        updateBalances(startingAt: transaction) { (success, errorString) in
            if success {
                self.stack.context.performAndWait {
                    self.stack.save()
                }
            } else {
                print(errorString)
            }
        }
    }
    
    func updateBalances(startingAt: Transaction, completionHandlerForUpdates: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        getUnsavedTransactions() { (success, result, errorString) in
            
            if success {
                var updateList = self.sortTransactions(result!)
                let updateCount = updateList.count
                let modified = updateList.index(of: startingAt)
                let shouldRemove: Bool = (updateCount - modified!) > 2
                
                // Remove transactions that don't need to be updated
                if shouldRemove {
                    updateList.removeSubrange((modified!+2)..<updateCount)
                }
                
                for tran in updateList {
                    let tranDate = tran.date
                    let tranDesc = tran.title
                    let tranIndex = updateList.index(of: tran)
                    
                    print("\(tranDate!) index: \(tranIndex!) - desc: \(tranDesc!)")
                }
                
                if updateCount == 1 {
                    startingAt.newBalance = startingAt.amount
                 } else {
                    
                    if modified == 0 {
                        startingAt.newBalance = startingAt.amount + updateList[1].newBalance
                    } else {
                        
                        for index in stride(from: modified as! Int, to: -1, by: -1) {
                            
                            let current = updateList[index]
                            
                            if index == (updateCount-1) {
                                current.newBalance = current.amount
                                updateList[index-1].newBalance = updateList[index-1].amount + current.newBalance
                            } else {
                                let previous = updateList[index+1]
                                current.newBalance = current.amount + previous.newBalance
                            }
                        }
                    }
                }
                
                self.wallet?.balance = updateList[0].newBalance
                
                completionHandlerForUpdates(true, nil)
                
            } else {
                
                completionHandlerForUpdates(false, errorString)
            }
            
        }
    }
    
    func getUnsavedTransactions(completionHandlerForUnsaved: @escaping (_ succes: Bool, _ result: [Transaction]?, _ errorString: String?) -> Void) {
        
        var transactionArray = [Transaction]()
        
        do {
            transactionArray = try stack.context.fetch(staticFetchRequest) as! [Transaction]
        } catch let e as NSError {
            let error = "Error while trying to perform a search: \n\(e)\n\(String(describing: stack.context))"
            completionHandlerForUnsaved(false, nil, error)
            
        }
        
        completionHandlerForUnsaved(true, transactionArray, nil)
    
    }

    
  
    
    func filterByDate(transactions: [Transaction], fromDate: NSDate) -> [Transaction] {
        
        let updateTransactions = transactions.filter({
            $0.date?.compare(fromDate as Date) == ComparisonResult.orderedDescending
        })
        
        return updateTransactions

    }
    
    func getTransactionsSum(_ transactions: [Transaction]) -> Double {
        
        var sum = 0.0
        for i in 0...transactions.count - 1 {
            sum += transactions[i].amount
        }
        
        return sum
    }
    
    func sortTransactions(_ list: [Transaction]) -> [Transaction] {
        let sortedTransactions = list.sorted(by: {
            $0.date?.compare($1.date! as Date) == ComparisonResult.orderedDescending
        })
        
        print(sortedTransactions)
        return sortedTransactions
    }
    
    func deleteTransation(indexPath: IndexPath, completionHandlerForDelete: @escaping (_ success: Bool, _ error: String?) -> Void) {
        
        let currentRow = indexPath.row
        let nextRow = currentRow - 1
        let prevRow = currentRow + 1
        let nextIndexPath = NSIndexPath(row: nextRow, section: indexPath.section)
        let prevIndexPath = NSIndexPath(row: prevRow, section: indexPath.section)
        
        let deleteTransaction = self.fetchedResultsController?.object(at: indexPath)
        
        if indexPath.row == 0 {
            if (fetchedResultsController?.fetchedObjects?.count)! > 1 {
                let prevTransaction = self.fetchedResultsController?.object(at: prevIndexPath as! IndexPath)
                self.stack.context.performAndWait {
                    self.fetchedResultsController?.managedObjectContext.delete(deleteTransaction!)
                    self.wallet?.balance = (prevTransaction?.newBalance)!
                    self.stack.save()
                    completionHandlerForDelete(true, nil)
                }
            } else {
                self.stack.context.performAndWait {
                    self.fetchedResultsController?.managedObjectContext.delete(deleteTransaction!)
                    self.wallet?.balance = 0.0
                    self.stack.save()
                    completionHandlerForDelete(true, nil)
                }
            }

        } else {
            
            let nextTransaction = self.fetchedResultsController?.object(at: nextIndexPath as! IndexPath)
            self.fetchedResultsController?.managedObjectContext.delete(deleteTransaction!)
            self.updateBalances(startingAt: nextTransaction!) { (success, errorString) in
                if success {
                    self.stack.context.performAndWait {
                        self.stack.save()
                        completionHandlerForDelete(true, nil)
                    }
                } else {
                    completionHandlerForDelete(false, errorString)
                }
            }
        }
    }
    
    func getNextTransaction(fromTransaction: Transaction, completionHandlerForNext: @escaping (_ result: Transaction?) -> Void) {
        
        var nextTransaction: Transaction?
        let currentIndex = fetchedResultsController?.fetchedObjects?.index(of: fromTransaction)
        let nextIndex = currentIndex! - 1
        
        if currentIndex == 0 {
            completionHandlerForNext(fromTransaction)
        } else {
            nextTransaction = self.fetchedResultsController?.fetchedObjects![nextIndex]
            completionHandlerForNext(nextTransaction)
        }
    
    }
    
    func calculateDateBalances() {
        var sum : Double = 0.0
        var minus : Double = 0.0
        var total : Double = 0.0
        
        if let filteredTransactions = fetchedResultsController?.fetchedObjects {
            if filteredTransactions.count > 0 {
                for transaction in filteredTransactions {
                    if transaction.amount > 0 {
                        sum += transaction.amount
                    } else if transaction.amount < 0 {
                        minus += transaction.amount
                    }
                }
            } else {
                // send notification and show message saying that there are not any transactions in the requested date(s)
            }
        }
        
        total = sum + minus
        
        earningsLabel.text = "\(sum.currency!)"
        expensesLabel.text = "\(minus.currency!)"
        totalBalanceLabel.text = "\(total.currency!)"
        
        earningsLabel.setNeedsDisplay()
        expensesLabel.setNeedsDisplay()
        totalBalanceLabel.setNeedsDisplay()
    }
}
