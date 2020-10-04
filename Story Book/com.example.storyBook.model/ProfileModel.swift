//
//  Profile.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 7/27/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import Foundation

import FirebaseAuth

import FirebaseDatabase

import FirebaseStorage

class ProfileModel {

    static var collection : DatabaseReference {

        get {

            return Database.database().reference().child("Profile")

        }
    }
    
    
    static var profileFeeds : DatabaseReference {
        
        get {
            
            return Database.database().reference().child("profile_posts")
            
        }
    }
    
    static var profileManagerFeeds : DatabaseReference {
        
        get {
            
            return Database.database().reference().child("ProfileManager")
            
        }
        
    }
    
    var firstName : String = ""
    
    var lastName : String = ""
    
    var birthDay : String = ""
    
    var country : String = ""
    
    var profileImage : URL?
    
    var profileId : String = ""
    
    init?(_ snapshot : DataSnapshot) {
        
        guard let profileValue = snapshot.value as? [String : Any] else { return }
        
        self.firstName = profileValue["first_Name"] as? String ?? ""
        
        self.lastName = profileValue["last_Name"] as? String ?? ""
        
        self.country = profileValue["Country"] as? String ?? ""
        
        self.birthDay = profileValue["dateOfBirth"] as? String ?? ""
        
        if let profileImage = profileValue["profile_Image"] as? String{
            
            self.profileImage = URL(string: profileImage)
            
        }
        
        self.profileId = snapshot.key
        
    }

}
