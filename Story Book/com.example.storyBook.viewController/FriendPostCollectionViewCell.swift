//
//  FriendPostCollectionViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/5/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class FriendPostCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var friendPostBackgroundView: UIView!
    @IBOutlet weak var addCommentTextField: UITextField!
    @IBOutlet weak var postImage: UIImageView!
    
    override func awakeFromNib() {
        
        // Edited on friendPostBackgroundView
        friendPostBackgroundView.layer.cornerRadius = 22
        friendPostBackgroundView.layer.borderWidth = 1
        friendPostBackgroundView.layer.borderColor = UIColor(named: "FriendPost_Border_Color")!.cgColor
        
        // Edited on addCommentTextField
        addCommentTextField.layer.cornerRadius = 12.5
        addCommentTextField.layer.borderWidth = 1
        addCommentTextField.layer.borderColor = UIColor(named: "FriendPost_CommentFieldBorder_Color")!.cgColor
        
        //Edited on postImage
        postImage.layer.borderWidth = 0.3
        postImage.layer.borderColor = UIColor(named: "FriendPost_Border_Color")!.cgColor
    }
    
}
