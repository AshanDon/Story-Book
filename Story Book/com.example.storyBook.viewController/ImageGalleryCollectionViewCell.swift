//
//  ImageGalleryCollectionViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/8/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class ImageGalleryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageGalleryView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        
        //Edited on imageGalleryView
        //imageGalleryView.layer.cornerRadius = 12
        imageGalleryView.layer.borderColor = UIColor(named: "MyPost_Border_Color")!.cgColor
        imageGalleryView.layer.borderWidth = 1
        
        //imageView.layer.cornerRadius = 12
    }
}
