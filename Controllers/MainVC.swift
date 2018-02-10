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

class MainVC: UIViewController, UIGestureRecognizerDelegate  {
    
    let user = Auth.auth().currentUser
    let stack = CoreDataStack.sharedInstance
    let scrollView = UIScrollView()
    var subViews = [WalletView]()
    var newWallet: Wallet?
    var bottomConstraint: Constraint? = nil
    //let colors = [UIColor.green, UIColor.blue, UIColor.red, UIColor.orange]
    //var blockOperations: [BlockOperation] = []
    
    var fetchedResultsController : NSFetchedResultsController<Wallet> = { () -> NSFetchedResultsController<Wallet> in
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Wallet")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        //fetchRequest.predicate = NSPredicate(format: "users = %@", argumentArray: [user])
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.context, sectionNameKeyPath: nil, cacheName: nil) as! NSFetchedResultsController<Wallet>
        
        
        
        return fetchedResultsController
    }()
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//    init(fetchedResultsController fc : NSFetchedResultsController<Wallet>) {
//        super.init(nibName: nil, bundle: nil)
//        fetchedResultsController = fc
//
//    }
    
    @IBOutlet weak var addWalletButton: AddButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.bringSubview(toFront: addWalletButton)
        
        fetchedResultsController.delegate = self
    
        
        if fetchWallets().isEmpty {
            print("No wallets")
        } else {
            for wallet in fetchWallets() {
                let walletView = WalletView(frame: .zero, wallet: wallet)
                subViews.append(walletView)
            }
            setSubviewsLayout()
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func menuPressed(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ToggleSideMenu"), object: nil)
    }
    
    @IBAction func addWallet(_ sender: Any) {
        
        let addVC = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
        addVC.providesPresentationContextTransitionStyle = true
        addVC.definesPresentationContext = true
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.delegate = self
        self.present(addVC, animated: true, completion: nil)
        
    }
    
    func setSubviewsLayout() {
        // 2
        subViews.enumerated().forEach { index, subview in
            //subview.backgroundColor = colors[index]
            
            setGestureRecognizer(subview)
            addWalletView(index: index, subview: subview)
        }
        

    }
    
    func addWalletView(index: Int, subview: WalletView) {
        
        
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
                
                if self.bottomConstraint != nil {
                    self.bottomConstraint!.deactivate()
                }
                
                self.bottomConstraint = make.bottom.equalTo(0).constraint
            // 7
            default:
                
                make.top.equalTo(subViews[index - 1].snp.bottom).offset(40)
            }
        }
        self.view.layoutIfNeeded()
    }
    
    func setGestureRecognizer(_ walletView: WalletView) {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectWalletRecognizer(_:)))
        tapRecognizer.delegate = self
        walletView.addGestureRecognizer(tapRecognizer)
        
    }
    
    @objc func selectWalletRecognizer(_ recognizer: UIGestureRecognizer) {
        let viewTapped = recognizer.view as! WalletView
        let wallet = viewTapped.wallet
        performSegue(withIdentifier: "walletSegue", sender: wallet)
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "walletSegue" {
            let wallet = sender as! Wallet
            let destination = segue.destination as! WalletViewController
            destination.wallet = wallet
            
        }
    }
//    func setWalletView(_ wallet: Wallet) -> UIView {
//
//        let walletView = UIView()
//        walletView.backgroundColor = UIColor.black
//
//        let nameLabel = UILabel()
//        nameLabel.text = wallet.walletName
//        nameLabel.textColor = UIColor.white
//        nameLabel.textAlignment = NSTextAlignment.center
//        walletView.addSubview(nameLabel)
//
//
//        nameLabel.snp.makeConstraints { (make) in
//
//            make.center.equalTo(walletView)
//            make.height.lessThanOrEqualTo(walletView)
//            make.width.lessThanOrEqualTo(walletView)
//
//        }
//
//        return walletView
//    }
    
    func fetchWallets() -> [Wallet] {
        var wallets = [Wallet]()
        
        let fc = fetchedResultsController
        do {
            try fc.performFetch()
            wallets = fc.fetchedObjects!
        } catch let e as NSError {
            print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
        }
        
        return wallets
    }

}

extension MainVC: NSFetchedResultsControllerDelegate {

//    func sendProperties(name: String, balance: Float) {
//        self.stack.context.performAndWait {
//            self.newWallet = Wallet(walletName: name, balance: balance, createdAt: NSDate(), context: self.stack.context)
//            self.stack.save()
//        }
//    }

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { }

    // Source: https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController/issues/13
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {

        case .insert:
            let newWallet = anObject as! Wallet
            let newWalletView = WalletView(frame: .zero, wallet: newWallet)
            self.setGestureRecognizer(newWalletView)
            self.subViews.insert(newWalletView, at: (newIndexPath!.row))
            self.addWalletView(index: newIndexPath!.row, subview: newWalletView)

        case .delete:
            self.subViews.remove(at: (indexPath?.row)!)

        case .update:
            let newWallet = anObject as! Wallet
            let newWalletView = WalletView(frame: .zero, wallet: newWallet)
            self.setGestureRecognizer(newWalletView)
            self.subViews[(indexPath?.row)!] = newWalletView

        case .move:
            let walletView = self.subViews[(indexPath?.row)!]
            self.subViews.remove(at: (indexPath?.row)!)
            self.subViews.insert(walletView, at: (indexPath?.row)!)
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) { }
}

extension MainVC: AddViewControllerDelegate {

    func sendProperties(name: String, balance: Float) {
        self.stack.context.performAndWait {
            self.newWallet = Wallet(walletName: name, balance: balance, createdAt: NSDate(), context: self.stack.context)
            self.stack.save()
        }
    }

   
//    func createObject(_ object: NSManagedObject) {
//
//        self.stack.context.performAndWait {
//            let _ = object
//            //self.executeSearch()
//            self.stack.save()
//        }
//
//    }

}

