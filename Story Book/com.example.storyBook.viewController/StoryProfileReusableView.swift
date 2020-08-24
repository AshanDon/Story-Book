//
//  StoryProfileReusableView.swift
//  Story Book
//
//  Created by Ashan Don on 8/12/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class StoryProfileReusableView: UICollectionReusableView {

    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundView.layer.cornerRadius = 10
        
        backgroundView.layer.borderColor = UIColor.white.cgColor
        
        backgroundView.layer.borderWidth = 2
        
        profileImage.layer.cornerRadius = 10
        
        profileImage.layer.shadowColor = UIColor.black.cgColor
        
        profileImage.layer.shadowOffset = CGSize(width: 0, height: 0.1)
        
        profileImage.layer.shadowRadius = 0.3
        
        profileImage.layer.opacity = 0.5
        
    }
    
}
