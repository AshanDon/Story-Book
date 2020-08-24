//
//  StoryPostViewController.swift
//  Story Book
//
//  Created by Ashan Don on 8/13/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class StoryPostViewController: UIViewController {
    
    @IBOutlet weak var addStoryButton: UIButton!
    
    @IBOutlet weak var storyView: UIView!
    
    public var localizationResouce : String?
    
    public var storyImageData : Data?

    override func viewDidLoad() {
        super.viewDidLoad()

        addStoryButton.layer.borderColor = UIColor(named: "LoginView_TextFieldBorder_Color")!.cgColor

        addStoryButton.layer.borderWidth = 2

        addStoryButton.layer.cornerRadius = 5
        
        if let languageResouce = localizationResouce {

            let addStoryButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "SHARE_BUTTON")

            addStoryButton.setTitle(addStoryButtonTitle, for: .normal)

        }
        
        if let storyImage = storyImageData {
            
            let imageView = UIImageView(image: UIImage(data: storyImage))
            
            imageView.frame = storyView.bounds
            
            storyView.addSubview(imageView)
            
        }
    }

    @IBAction func backButtonDidTouch() {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func addStoryPressed() {
        
    }
    
}
