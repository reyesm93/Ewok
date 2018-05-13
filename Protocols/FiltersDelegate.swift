//
//  FiltersDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 5/6/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation
import UIKit

protocol  FiltersDelegate : class {
    func applyFilter(controller: UIViewController, filterType: Filters, filterArgument: [Any]?)
}
