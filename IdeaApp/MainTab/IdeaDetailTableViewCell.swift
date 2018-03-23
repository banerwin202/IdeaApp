//
//  IdeaDetailTableViewCell.swift
//  
//
//  Created by Ban Er Win on 22/03/2018.
//

import UIKit

class IdeaDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userUsernameLabel: UILabel!
    
    @IBOutlet weak var userCommentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
