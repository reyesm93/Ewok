//
//  WalletView.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/9/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import SnapKit

class WalletView: UIView {
    
    var wallet : Wallet!
    var nameLabel = UILabel()
    var balanceLabel = UILabel()
    
    
    init(frame: CGRect, wallet: Wallet) {
        super.init(frame: frame)
        self.wallet = wallet
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        backgroundColor = UIColor.black
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
        setLabels()
    
    }


    
    func setLabels() {
        
        
        nameLabel.text = wallet.walletName
        balanceLabel.text = String(wallet.balance)
        
        nameLabel.textAlignment = NSTextAlignment.center
        balanceLabel.textAlignment = NSTextAlignment.center
        
        nameLabel.textColor = UIColor.white
        balanceLabel.textColor = UIColor.white
        
        self.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(30)
            make.height.lessThanOrEqualTo(self)
            make.width.lessThanOrEqualTo(self)
            
        }
        
        self.addSubview(balanceLabel)
        
        balanceLabel.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self)
            make.bottom.equalTo(self).offset(-30)
            make.height.lessThanOrEqualTo(self)
            make.width.lessThanOrEqualTo(self)
            
        }
        
        
    }
}

