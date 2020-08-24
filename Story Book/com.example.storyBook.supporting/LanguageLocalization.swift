//
//  LanguageLocalization.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/21/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import Foundation

class LanguageLocalization {
    
    public static let shared = LanguageLocalization()
    
    public func genaretedLanguageLocalization(languageResouce : String,identification : String) -> String{
        let path = Bundle.main.path(forResource: languageResouce, ofType: "lproj")
        let bundle = Bundle.init(path: path!)! as Bundle
        let retuneValue : String? = bundle.localizedString(forKey: identification, value: identification, table: nil)
        return retuneValue!
    }
}
