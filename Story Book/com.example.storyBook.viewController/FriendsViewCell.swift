//
//  FriendsViewCell.swift
//  Story Book
//
//  Created by Ashan Don on 9/9/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseAuth

import FirebaseDatabase

class FriendsViewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var followButton: UIButton!

    public var selectedProfileId : String?
    
    public var localizationResouce : String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
        followButton.layer.cornerRadius = 10
        
        followButton.layer.borderWidth = 2
        
        followButton.layer.borderColor = UIColor(named: "Notification_ConfirmButtonBorder_Color")!.cgColor
        
        followButton.layer.backgroundColor = UIColor(named: "Notification_ConfirmButtonBackground_Color")!.cgColor
        
    }
    
    
    @IBAction func followButtonPressed(_ sender: Any) {
        
        if let profileId = selectedProfileId {
            
            guard let currentUserId = Auth.auth().currentUser?.uid else { return }
            
            ProfileManager.followFriend(profileId, currentUserId)
            
        }
        
    }
    
    public func setButtonTitle(){
        
        if let languageResouce = localizationResouce {
            
            let buttonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "FOLLOW")
            
            followButton.setTitle(buttonTitle, for: .normal)
            
        }
        
    }
}
