//
//  Extension.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 7/22/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController {
    
    class func displayLoading(withView : UIView) -> UIView {
        
        let spinnerView = UIView.init(frame: withView.bounds)
        
        spinnerView.backgroundColor = UIColor.clear
        
        let ai = UIActivityIndicatorView(style: .large)
        
        ai.startAnimating()
        
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            
            spinnerView.addSubview(ai)
            
            ai.addSubview(spinnerView)
            
        }
        
        return spinnerView
    }
    
    class func removeLoading(spinner : UIView){
        
        DispatchQueue.main.async {
            
            spinner.removeFromSuperview()
            
        }
        
    }
    
}
