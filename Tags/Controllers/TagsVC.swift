//
//  TagsTableVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 5/31/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class TagsVC : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var tagsTableView: UITableView!
    
    // MARK: Properties

    let stack = CoreDataStack.sharedInstance
    var tagsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Tag")
    var isEditingTags = false
    var invokedByTransaction: Transaction?
    weak var transactionVC: TransactionDetailVC?
    var fetchedResultsController : NSFetchedResultsController<Tag>? {
        didSet {
            // Whenever the frc changes, we execute the search and
            // reload the table
            fetchTags()
            fetchedResultsController?.delegate = self
            tagsTableView.dataSource = self
            tagsTableView.reloadData()
        }
    }
    
    // MARK: Initializer Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        menuButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showSideMenu))
//        self.navigationItem.leftBarButtonItem = menuButton
        //tagsTableView.dataSource = self
        tagsTableView.delegate = self
        tagsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TagCell")
        setFetchRequest()
        
        if transactionVC?.newTransaction != nil {
            transactionVC?.newTransaction?.tags = Set<Tag>()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isEditingTags {
            
        }
    }
    
    // MARK: Actions
    
    @IBAction func addNewTag(_ sender: Any) {
        
        if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddViewController") as? AddVC {
            controller.providesPresentationContextTransitionStyle = true
            controller.definesPresentationContext = true
            controller.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            controller.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            controller.objectToAdd = ObjectType.tag
            controller.saveDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK: Methods
    
    func setFetchRequest() {
    
        tagsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: tagsFetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Tag>
    }

    func fetchTags() -> [Tag] {
        var tags = [Tag]()
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
                tags = fc.fetchedObjects!
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(String(describing: fetchedResultsController))")
            }
        }
        return tags
    }
    
}

extension TagsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchTags().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagCell")
        if let tag = fetchedResultsController?.object(at: indexPath) {
            cell?.textLabel?.text = tag.name
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell?.selectionStyle = .none
            cell?.isUserInteractionEnabled = true
            if isEditingTags {
                
                if let transactionToEdit = invokedByTransaction {
                    if let transactionTags = transactionToEdit.tags {
                        if transactionTags.contains(tag) {
                            cell?.accessoryType = .checkmark
                        }
                    }
                } else {
                    if transactionVC?.newTransaction?.tags != nil {
                        if (transactionVC?.newTransaction?.tags?.contains(tag))! {
                           cell?.accessoryType = .checkmark
                        }
                    }
                }
            } else {
                cell?.accessoryType = .disclosureIndicator
            }
        }
        guard let unwrappedCell = cell else { return UITableViewCell() }
        return unwrappedCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let tag = fetchedResultsController?.object(at: indexPath) {
            let cell = tableView.cellForRow(at: indexPath)
            if let transactionToEdit = invokedByTransaction {
                if let transactionTags = transactionToEdit.tags {
                    if transactionTags.contains(tag) {
                        tag.removeFromTransaction(transactionToEdit)
                        cell?.accessoryType = .none
                    } else {
                        tag.addToTransaction(transactionToEdit)
                        cell?.accessoryType = .checkmark
                    }
                } else {
                    if transactionVC?.newTransaction?.tags != nil {
                        if (transactionVC?.newTransaction?.tags?.contains(tag))! {
                            transactionVC?.newTransaction?.tags?.remove(tag)
                            cell?.accessoryType = .none
                        } else {
                            transactionVC?.newTransaction?.tags?.insert(tag)
                            cell?.accessoryType = .checkmark
                        }
                    }
                }
            }
        }
    }
}

extension TagsVC : SaveObjectDelegate {
    func saveObject(controller: UIViewController, saveObject: NSManagedObject, isNew: Bool, completionHandlerForSave: @escaping (Bool) -> Void) {
        self.stack.context.performAndWait {
            self.stack.save()
            completionHandlerForSave(true)
        }
    }
}
