//
//  CalendarDelegate.swift
//  Ewok
//
//  Created by Arturo Reyes on 3/23/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

protocol CalendarDelegate: class {
    func sendDate(view: UIView, date: Date, toDate: Date?)
}
