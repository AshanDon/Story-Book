//
//  FriendPostCollectionViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/5/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseDatabase

import FirebaseAuth

class FriendPostCollectionViewCell: UICollectionViewCell {


    @IBOutlet weak var friendPostBackgroundView: UIView!
    
    @IBOutlet weak var addCommentTextField: UITextField!
    
    @IBOutlet weak var postImage: UIImageView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileName: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var CurrentUserImage: UIImageView!
    
    
    private var currentProfile : ProfileModel?
    
    public var tagFriendsList : [String] = []
    
    var userRef : DatabaseReference? {
        
        willSet {
            
            resetUser()
            
        }
        
        didSet {
            
            userRef?.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
                
                guard let strongeSelf = self else { return }
                
                if let profile = ProfileModel(snapshot) {
                    
                    strongeSelf.currentProfile = profile
                    
                    strongeSelf.setup(profile)
                    
                }
            })
        }
    }
    
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
        
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        
        CurrentUserImage.layer.cornerRadius = 12
    }
    
    private func resetUser() {
        
        profileName.text = ""
        
        profileImage.image = nil
        
    }
    
    
    private func setup(_ profile : ProfileModel) {
        
        let fullName = "\(profile.firstName) \(profile.lastName)"
        
        if tagFriendsList.count > 0 && !tagFriendsList[0].elementsEqual("") {
            
            var title = String()
            
            if tagFriendsList.count == 1 {
                
                title = "\(fullName) with \(tagFriendsList[0])"
                
            } else {
                
                title = "\(fullName) with \(tagFriendsList[0]) and \(tagFriendsList.count - 1) others"
                
            }
            
            profileName.text = title
            
        } else {
        
            profileName.text = fullName
            
        }
        
        
        
        if let imageURL = profile.profileImage {
            
            profileImage.sd_cancelCurrentImageLoad()
            
            profileImage.sd_setImage(with: imageURL, completed: nil)
            
        }
        
        loadCurrentProfileImage()
        
    }
    
    private func loadCurrentProfileImage(){
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let  currentUserRef = ProfileModel.collection.child(userId)
        
        currentUserRef.observe(.value, with: { [weak self] (snapshot) in
            
            guard let strongeSelf = self else { return }
            
            guard let profileDetail = ProfileModel(snapshot) else { return }
            
            if let imageURL = profileDetail.profileImage{
                
                DispatchQueue.main.async {
                    
                    strongeSelf.CurrentUserImage.sd_cancelCurrentImageLoad()
                    
                    strongeSelf.CurrentUserImage.sd_setImage(with: imageURL, completed: nil)
                    
                }
                
            } 
        })
    }
    
    @IBAction func postSettingsButton(_ sender: Any) {
        
    }
}
