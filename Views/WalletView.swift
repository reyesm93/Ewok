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
    var deleteButton = UIButton()
    
    
    init(frame: CGRect, wallet: Wallet) {
        super.init(frame: frame)
        self.wallet = wallet
        setUpView()
    }
    // Was not created in storyboard but it needs initwithCoder
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        backgroundColor = UIColor.black
        translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 15
        setLabels()
        setDeleteButton()
    
    }
    
    func setDeleteButton() {
        deleteButton.setTitle("Delete", for: .normal)
        deleteButton.titleLabel!.text = "Delete"
        deleteButton.titleLabel!.textColor = UIColor.white
        
        self.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self).offset(-5)
            make.top.equalTo(self).offset(10)
        }
        
        deleteButton.addTarget(self, action: #selector(didTapDelete(sender:)), for: .touchUpInside)
        
    }
    
    @objc func didTapDelete(sender: UIButton!) {
        let currentWal = self.wallet
        let userInfo =  [ "wallet" : currentWal ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DeleteWallet"), object: nil, userInfo: userInfo)
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

