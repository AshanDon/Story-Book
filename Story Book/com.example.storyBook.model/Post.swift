//
//  Post.swift
//  Story Book
//
//  Created by Ashan Don on 8/23/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import Foundation

import FirebaseAuth

import FirebaseDatabase

import FirebaseStorage

class Post {
    
    static var collection : DatabaseReference {
        
        get{
            
            return Database.database().reference().child("posts")
            
        }
    }
    
    static func newPost(userId : String, caption : String, imageDownloadURL : String,location : String,tagPepole : [String]) {
        
        let datePosted = Date.timeIntervalSinceReferenceDate
        
        guard let key = ProfileModel.collection.childByAutoId().key else { return }
        
        let post : [String : Any] = ["user" : userId,
                                     "image" : imageDownloadURL,
                                     "caption" : caption,
                                     "location" : location,
                                     "pepole" : tagPepole,
                                     "date" : datePosted
                                    ]
        
        Post.collection.updateChildValues(["\(key)" : post])
                                     
    }
    
    var postDate : Date = Date()
    
    var userId : String = ""
    
    var caption : String = ""
    
    var imageDownloadURL : URL?
    
    var location : String = ""
    
    var tagPepole : [String] = []
    
    init?(_ napshot : DataSnapshot) {
        
        guard let postValue = napshot.value as? [String : Any] else { return nil}
        
        guard let date = postValue["date"] as? Double else { return nil}
        
        guard let userId = postValue["user_Id"] as? String else { return nil}
        
        guard let caption = postValue["caption"] as? String else { return nil}
        
        guard let image = postValue["post_Image"] as? String else { return nil }
        
        guard let postImage = URL(string: image) else { return nil}
        
        guard let location = postValue["location"] as? String else { return nil}
        
        guard let tagPepole = postValue["tagPepole"] as? [String] else { return nil}
        
        self.postDate = Date.init(timeIntervalSince1970: date)
        
        self.userId = userId
        
        self.caption = caption
        
        self.imageDownloadURL = postImage
        
        self.location = location
        
        self.tagPepole = tagPepole
        
    }
}
