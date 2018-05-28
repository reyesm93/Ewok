//
//  SideMenuCells.swift
//  Ewok
//
//  Created by Arturo Reyes on 5/28/18.
//  Copyright © 2018 Arturo Reyes. All rights reserved.
//

import UIKit

class ProfileHeaderCell : UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}

class SideMenuCell : UITableViewCell {

    @IBOutlet weak var sectionCellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }


}
