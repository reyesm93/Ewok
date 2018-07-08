//
//  SectionContainerVC.swift
//  Ewok
//
//  Created by Arturo Reyes on 7/7/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

enum SectionViewControllerID: String {
    case home = "HomeVC"
    case tags = "TagsVC"
}

class SectionContainerVC: UIViewController, SelectedSectionDelegate {
    
    var currentViewController: UIViewController?

    // MARK: Properties
    private lazy var homeViewController: HomeVC? = {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeVC") as? HomeVC {
            self.addViewController(asChildVC: viewController)
            return viewController
        }
        return nil
    }()
    
    private lazy var tagsViewController: TagsVC? = {
        if let viewController = UIStoryboard(name: "Tags", bundle: nil).instantiateViewController(withIdentifier: "TagsVC") as? TagsVC {
            self.addViewController(asChildVC: viewController)
            return viewController
        }
        return nil
    }()

    // MARK: Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuButton = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showSideMenu))
        navigationItem.setLeftBarButton(menuButton, animated: true)
        
        currentViewController = homeViewController
        addViewController(asChildVC: currentViewController!)
        
    }
    
    // MARK: Methods
    
    private func addViewController(asChildVC viewController: UIViewController) {
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func removeViewController(asChildVC viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    /// Changes View to selected view controller
    func selectedSection(viewController: UIViewController) {
        if currentViewController != nil {
            removeViewController(asChildVC: currentViewController!)
            addViewController(asChildVC: viewController)
            currentViewController = viewController
        }
    }


}
