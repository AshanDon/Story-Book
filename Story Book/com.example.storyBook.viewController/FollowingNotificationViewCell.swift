//
//  FollowingNotificationViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/10/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class FollowingNotificationViewCell: UITableViewCell {

    @IBOutlet weak var followingNotificationView: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var massageButton: UIButton!
    @IBOutlet weak var followingDetailLabel: UILabel!
    
    public var notificationDelagete : NotificationDelagete?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Edited on Following Notification View
        followingNotificationView.layer.borderColor = UIColor(named: "MyPost_Border_Color")!.cgColor
        followingNotificationView.layer.borderWidth = 1
        
        // Edited on Delete Button
        massageButton.layer.cornerRadius = 6
        massageButton.layer.borderColor = UIColor(named: "Notification_BottonBorder_Color")!.cgColor
        massageButton.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func messageButtonDidTouch(_ sender: Any) {
        
        if let followingDetail = followingDetailLabel.text {
            
            let splitDetail = followingDetail.split(separator: " ")
            
            let profileName = "\(String(splitDetail[0])) \(String(splitDetail[1]))"
            
            if let profileImage = profileImage.image{
                
                notificationDelagete?.presentChatHeaderView(profileName,profileImage)
                
            }
        
        }
    }
}
