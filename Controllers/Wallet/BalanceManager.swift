//
//  BalanceManager.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/2/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation

extension WalletViewController {
    
    func updateBalances(fromIndex: IndexPath) {
        
        let updatedTransaction = fetchedResultsController?.object(at: fromIndex)
        let count = fetchedResultsController?.fetchedObjects?.count
        let newIndex = fetchedResultsController?.fetchedObjects?.index(of: updatedTransaction!) as! Int
        
        if (count == 1) {
            
            if updatedTransaction?.newBalance != (updatedTransaction?.amount)! {
                updatedTransaction?.newBalance = (updatedTransaction?.amount)!
            }
            wallet?.balance = (updatedTransaction?.newBalance)!
        } else {
            
            if newIndex != 0 {
                
                for i in stride(from: newIndex, to: 0, by: -1) {

                    //i+1 causes to search for objext outside of fetchedobjects bounds, not iteration boundds
                    
                    let current = fetchedResultsController?.fetchedObjects![i]

                    if count! - i == 1 {
                        current?.newBalance = (current?.amount)!
                        let next = fetchedResultsController?.fetchedObjects![i-1]
                        next?.newBalance = (current?.newBalance)! + (next?.amount)!
                    } else {
                        let previous = fetchedResultsController?.fetchedObjects![i+1]
                        current?.newBalance = (previous!.newBalance) + (current?.amount)!
                        
                    }
                    
                    
                    if i == 0 {
                        wallet?.balance = (current?.newBalance)!
                    }
                    
                }
                
            } else {
                
                let previous = fetchedResultsController?.fetchedObjects![1]
                let current = fetchedResultsController?.fetchedObjects![0]
                current?.newBalance = (previous?.newBalance)! + (current?.amount)!
                wallet?.balance = (current?.newBalance)!
            }
            
        }
        
    }
    
    func getTransactions(fromDate: NSDate) -> [Transaction] {
        
        let updateTransactions = fetchedResultsController?.fetchedObjects?.filter({
            $0.createdAt?.compare(fromDate as Date) == ComparisonResult.orderedDescending
        })
        
        return (updateTransactions)!
    }
    
    func getTransactionsSum(_ transactions: [Transaction]) -> Double {
        
        var sum = 0.0
        for i in 0...transactions.count - 1 {
            sum += transactions[i].amount
        }
        
        return sum
    }
    
}
