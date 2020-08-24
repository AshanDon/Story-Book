//
//  FriendStoryCollectionViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/5/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class FriendStoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    
    override func awakeFromNib() {
        
        storyImage.layer.cornerRadius = 10
        
        storyImage.layer.masksToBounds = true
        
        storyImage.layer.borderWidth = 2
        
        storyImage.layer.borderColor = UIColor(named: "FriendsStory_Border_Color")!.cgColor
        
        storyImage.layer.shadowColor = UIColor.black.cgColor
        
        storyImage.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        
        storyImage.layer.shadowRadius = 0.3
        
        storyImage.layer.opacity = 0.5
        
        let gestureRecognizer = UIGestureRecognizer(target: self, action: #selector(profileDidTouch))
        
        storyImage.isUserInteractionEnabled = true
        
        storyImage.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func profileDidTouch(){
        
        print("Done")
    }
}
