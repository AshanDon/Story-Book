//
//  NotificationViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/9/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class NotificationViewCell: UITableViewCell {

    @IBOutlet weak var notifcationBorderView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var postImgeView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Edited on notifcationBorderView
        notifcationBorderView.layer.borderColor = UIColor(named: "MyPost_Border_Color")!.cgColor
        notifcationBorderView.layer.borderWidth = 1
        
   
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
