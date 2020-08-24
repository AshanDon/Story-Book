//
//  TagPeopleTableViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 7/3/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class TagPeopleTableViewCell: UITableViewCell {

    @IBOutlet weak var mainBackgroundView: UIView!
    @IBOutlet weak var tagPeopleLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mainBackgroundView.layer.borderColor = UIColor(named: "Segment_Border_Color")!.cgColor
        mainBackgroundView.layer.borderWidth = 1
        
    }
    
    public func setLanguageLocalization(resouce : String){
        
        tagPeopleLable.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: resouce, identification: "TAG_PEOPLE")
    }
}
