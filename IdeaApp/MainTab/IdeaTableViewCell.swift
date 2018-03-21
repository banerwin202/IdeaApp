//
//  IdeaTableViewCell.swift
//  IdeaApp
//
//  Created by Ban Er Win on 21/03/2018.
//  Copyright © 2018 Ban Er Win. All rights reserved.
//

import UIKit

class IdeaTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
