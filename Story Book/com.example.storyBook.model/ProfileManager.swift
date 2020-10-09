//
//  ProfileManager.swift
//  Story Book
//
//  Created by Ashan Don on 9/12/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import Foundation

import FirebaseDatabase

class ProfileManager {
    
    static var colloection : DatabaseReference {
        
        get {
            
            return Database.database().reference().child("ProfileManager")
            
        }
        
    }
    
    var profileId : String = ""
    
    var status : String = ""
    
    var date : Double = 0.0
    
    var active : String = ""
    
    init?(_ snapshot : DataSnapshot) {
        
        guard let profileValue = snapshot.value as? [String : Any] else { return nil}
        
        guard let profileId = profileValue["ProfileID"] as? String else { return nil }
        
        guard let status = profileValue["Status"] as? String else { return nil }
        
        guard let date = profileValue["Date"] as? Double else { return nil }

        guard let active = profileValue["Active"] as? String else { return nil }

        self.profileId =  profileId

        self.status = status

        self.date = date

        self.active = active
        
    }
    
    static public func followFriend(_ followerId : String, _ currentUserId : String) {
        
        let followDate = Date.timeIntervalSinceReferenceDate
        
        let followDetails : [String : Any] = ["ProfileID": followerId,
                                              "Status" : "FOLLOW",
                                              "Date" : followDate,
                                              "Active" : "YES"
                                              ]
        
        let profileManageFeed = ProfileModel.profileManagerFeeds
        
        profileManageFeed.child(currentUserId).updateChildValues([followerId : followDetails])
        
    }
    
    
    static public func unfollowFriend(_ unfollowId : String, _ currentUserId : String){
        
        let childUpdates = ["/\(currentUserId)/\(unfollowId)/Status" : "UNFOLLOW"]
        
        colloection.updateChildValues(childUpdates)
        
    }
}
