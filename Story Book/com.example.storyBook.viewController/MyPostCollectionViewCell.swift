//
//  MyPostCollectionViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/7/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class MyPostCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var myPostImageView: UIImageView!
    
    override func awakeFromNib() {
        
        //Edited on myPostImageView
        myPostImageView.layer.cornerRadius = 12
        myPostImageView.layer.borderWidth = 1
        myPostImageView.layer.borderColor = UIColor(named: "MyPost_Border_Color")!.cgColor
    }
}
