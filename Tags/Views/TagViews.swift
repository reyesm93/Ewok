//
//  TagViews.swift
//  Ewok
//
//  Created by Arturo Reyes on 6/9/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class TagCell : UITableViewCell {
    
    
    @IBOutlet weak var tagNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    
}
