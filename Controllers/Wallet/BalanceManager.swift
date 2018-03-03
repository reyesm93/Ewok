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
        let date = updatedTransaction?.createdAt

        for trans in getTransactions(fromDate: date!) {
            print(trans)
        }
        
    }
    
    func getTransactions(fromDate: NSDate) -> [Transaction] {
        
        let updateTransactions = fetchedResultsController?.fetchedObjects?.filter({
            $0.createdAt?.compare(fromDate as Date) == ComparisonResult.orderedDescending
        })
        
        return (updateTransactions)!
    }
    
}
