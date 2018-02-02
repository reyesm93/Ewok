//
//  GCDBlackBox.swift
//  Ewok
//
//  Created by Arturo Reyes on 2/1/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
