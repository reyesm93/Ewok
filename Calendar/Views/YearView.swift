//
//  MonthView.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/17/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class YearView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        setupViews()
    }
    
    let yearLbl : UILabel = {
        let lbl=UILabel()
        lbl.text="20XX"
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font=UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()


    func setupViews() {
        self.addSubview(yearLbl)
        yearLbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        yearLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        yearLbl.widthAnchor.constraint(equalToConstant: 250).isActive=true
        yearLbl.heightAnchor.constraint(equalTo: heightAnchor).isActive=true

    }
}

