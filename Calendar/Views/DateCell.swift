//
//  DateCell.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/17/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//


import UIKit

class DateCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor=UIColor.clear
        layer.masksToBounds=true
        self.isUserInteractionEnabled = true
   
        setupViews()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.dayLabel.font = self.dayLabel.font.removeBold()
        self.dayLabel.textColor = .black
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true

    }
    
    
    var dayLabel: UILabel = {
        let label = UILabel()
        label.text = "00"
        label.textAlignment = .center
        label.font=UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    func setupViews() {
        contentView.addSubview(dayLabel)
        dayLabel.topAnchor.constraint(equalTo: topAnchor).isActive=true
        dayLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        dayLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        dayLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive=true
    }
    
    
}
