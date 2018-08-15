//
//  TagDetailVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/1/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class TagDetailVC : UIViewController {
    
    // MARK: Outlets
    
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    
    // MARK: Properties
    
    var saveDelegate: SaveObjectDelegate?
    let stack = CoreDataStack.sharedInstance
    
    // MARK : Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: Actions
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        if nameTextField.text?.count != 0 {
            let newTag = Tag(name: nameTextField.text!, context: self.stack.context)
            saveDelegate?.saveObject(controller: self, saveObject: newTag, isNew: true) { (didSave) in
                if didSave {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
}
