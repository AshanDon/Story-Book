//
//  FindPeopleCell.swift
//  Story Book
//
//  Created by Ashan Don on 8/30/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class FindPeopleCell: UITableViewCell {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
