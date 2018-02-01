//
//  MainVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 1/19/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit
import SnapKit
import CoreData
import Firebase

class MainVC: UIViewController  {
    
    let user = Auth.auth().currentUser
    let stack = CoreDataStack.sharedInstance
    let scrollView = UIScrollView()
    let subViews = [UIView(), UIView(), UIView(), UIView()]
    let colors = [UIColor.green, UIColor.blue, UIColor.red, UIColor.orange]
    
    lazy var fetchedResultsController : NSFetchedResultsController<Wallet> = { () -> NSFetchedResultsController<Wallet> in
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Wallet")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        //fetchRequest.predicate = NSPredicate(format: "users = %@", argumentArray: [user])
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Wallet>
        
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    @IBOutlet weak var addWalletButton: AddButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.bringSubview(toFront: addWalletButton)
        //addWalletButton.snp.makeConstraints { (make) in
            //make.bottom.edges.equalTo(view).offset(10)
            //make.right.edges.equalTo(view).offset(10)
        //}
        
        setSubviewsLayout()
        
       
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
    }
    
    func setSubviewsLayout() {
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
    
}

extension MainVC: NSFetchedResultsControllerDelegate {
    
}
