//
//  MainVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/19/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit
import SnapKit

class MainVC: UIViewController {
    
    let scrollView = UIScrollView()
    let subViews = [UIView(), UIView(), UIView(), UIView()]
    let colors = [UIColor.green, UIColor.blue, UIColor.red, UIColor.orange]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        // 2
        subViews.enumerated().forEach { index, subview in
            subview.backgroundColor = colors[index]
            print("index: \(index)")
            // 3
            scrollView.addSubview(subview)
            subview.snp.makeConstraints { (make) in
                // 4
                
                make.centerX.lessThanOrEqualTo(scrollView)
                make.width.equalTo(scrollView).offset(-70)
                make.height.equalTo(scrollView).dividedBy(3)
                
                switch index {
                // 5
                case 0:
                    make.top.equalTo(50)
                // 6
                case subViews.count - 1:
                    make.top.equalTo(subViews[index - 1].snp.bottom).offset(40)
                    make.bottom.equalTo(0)
                // 7
                default:
                    make.top.equalTo(subViews[index - 1].snp.bottom).offset(40)
                }
            }
        }
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
    }
    
}
