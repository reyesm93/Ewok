//
//  MonthView.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/17/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class MonthView: UIView {
    
    var months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
    }
    
    let monthLbl : UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textAlignment = .center
        lbl.textColor = .black
        lbl.font=UIFont.boldSystemFont(ofSize: 16)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let nextBttn : UIButton = {
        let btn=UIButton()
        btn.setTitle(">", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(changeMonthAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let prevBttn: UIButton = {
        let btn=UIButton()
        btn.setTitle("<", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(changeMonthAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        return btn
    }()
    
    @objc func changeMonthAction(sender: UIButton) {
        if sender == nextBttn {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
        }
        monthLbl.text = "\(months[currentMonthIndex]) \(currentYear)"
    }
    
    func setupViews() {
        self.addSubview(monthLbl)
        monthLbl.topAnchor.constraint(equalTo: topAnchor).isActive=true
        monthLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive=true
        monthLbl.widthAnchor.constraint(equalToConstant: 150).isActive=true
        monthLbl.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        monthLbl.text="\(months[currentMonthIndex]) \(currentYear)"
        
        self.addSubview(nextBttn)
        nextBttn.topAnchor.constraint(equalTo: topAnchor).isActive=true
        nextBttn.rightAnchor.constraint(equalTo: rightAnchor).isActive=true
        nextBttn.widthAnchor.constraint(equalToConstant: 50).isActive=true
        nextBttn.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        
        self.addSubview(prevBttn)
        prevBttn.topAnchor.constraint(equalTo: topAnchor).isActive=true
        prevBttn.leftAnchor.constraint(equalTo: leftAnchor).isActive=true
        prevBttn.widthAnchor.constraint(equalToConstant: 50).isActive=true
        prevBttn.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
    }
}

