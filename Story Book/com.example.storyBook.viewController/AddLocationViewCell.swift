//
//  AddLocationViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 7/4/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class AddLocationViewCell: UITableViewCell {

    @IBOutlet weak var addLocationBakground: UIView!
    @IBOutlet weak var addLocationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addLocationBakground.layer.borderColor = UIColor(named: "Segment_Border_Color")!.cgColor
        addLocationBakground.layer.borderWidth  = 1
        
    }
    
    public func setLanguageLocalization(resouce : String){
        addLocationLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: resouce, identification: "ADD_LOCATION")
    }
    
    public func setSelectPlace(_ locationName : String?){
        
        if let selectLocationName = locationName {
            
            addLocationLabel.text = selectLocationName
            
        }
        
    }
}
