//
//  MonthHeader.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/26/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class MonthHeader : UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.cornerRadius=5
        layer.masksToBounds=true
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var monthLbl : UILabel = {
        
        let label = UILabel()
        label.textAlignment = .left
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints=false
        
        return label
        
    }()
    
    func setupViews() {
        addSubview(monthLbl)
        monthLbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthLbl.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        monthLbl.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        monthLbl.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
}
