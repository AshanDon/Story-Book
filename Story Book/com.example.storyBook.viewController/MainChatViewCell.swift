//
//  MainChatViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/11/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class MainChatViewCell: UITableViewCell {

    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
