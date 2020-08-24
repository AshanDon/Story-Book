//
//  Validation.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/20/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import Foundation

import UIKit

protocol ValidationErrorProtocol {
    func emptyTextFieldErrorMessage(title : String,message : String)
}


enum ValidationError : Error {
    
    case Empty
    
}

class Validation {
    
    public func validateText(text : String?) throws -> String{
        
        guard let text = text,!text.isEmpty else {
            
            throw ValidationError.Empty
            
        }
        
        return text
    }
    
    class func errorAlert(_ errorTitle : String,_ errorMessage : String,_ actionType : String) -> UIAlertController {
        
        let errorAlert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: actionType, style: .default) { (action) in
            
            errorAlert.dismiss(animated: true, completion: nil)
            
        }
        
        errorAlert.addAction(okAction)
        
        return errorAlert
    }
}
