//
//  FollowedNotificationViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/9/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class FollowedNotificationViewCell: UITableViewCell {

    @IBOutlet weak var followedNotificationView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Edited on followedNotificationView
        followedNotificationView.layer.borderColor = UIColor(named: "MyPost_Border_Color")!.cgColor
        followedNotificationView.layer.borderWidth = 1
        
        //Edited on confirm Confirm Button
        confirmButton.backgroundColor = UIColor(named: "Notification_ConfirmButtonBackground_Color")
        confirmButton.layer.cornerRadius = 6
        confirmButton.layer.borderColor = UIColor(named: "Notification_ConfirmButtonBorder_Color")!.cgColor
        confirmButton.layer.borderWidth = 1
        
        //Edited on Delete Button
        deleteButton.layer.cornerRadius = 6
        deleteButton.layer.borderColor = UIColor(named: "Notification_BottonBorder_Color")!.cgColor
        deleteButton.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
