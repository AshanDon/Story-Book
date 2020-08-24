//
//  SearchBarConteinerView.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 7/20/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class SearchBarConteinerView: UIView {

    let searchBar : UISearchBar
    
    init(customSearchBar : UISearchBar) {
        
        searchBar = customSearchBar
        
        super.init(frame: CGRect.zero)
        
        addSubview(searchBar)
        
    }
    
    convenience override init(frame: CGRect) {
        
        self.init(customSearchBar : UISearchBar())
        
        self.frame = frame
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        searchBar.frame = bounds
        
    }

}
