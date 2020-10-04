//
//  AllFriendsTableViewController.swift
//  Story Book
//
//  Created by Ashan Don on 9/8/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseAuth

import FirebaseDatabase

class AllFriendsTableViewController: UIViewController {

    @IBOutlet var friendsTableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    public var localizationResouce : String?
    
    private var friendList : NSMutableArray = []
    
    private var currentProfileId : String {
        
        return Auth.auth().currentUser!.uid
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let languageResouce = localizationResouce {
            
            let naviBarTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "NAVI_BAR_TITLE")
            
            let cancelButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CANCEL_BARBUTTON_ITEM")
            
            let navigationItem = UINavigationItem(title: naviBarTitle)
            
            let backButton = UIBarButtonItem(title: cancelButtonTitle, style: .plain, target: self, action: #selector(backButtonPressed))
            
            navigationItem.leftBarButtonItem = backButton
            
            navigationBar.setItems([navigationItem], animated: true)
            
        }
        
        friendsTableView.register(UINib(nibName: "FriendsViewCell", bundle: nil), forCellReuseIdentifier: "AllFriendView")
        
        friendsTableView.delegate = self
        
        friendsTableView.dataSource = self
        
        loadData()
        
    }
    
    @objc func backButtonPressed(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    private func loadData(){
        
        ProfileModel.collection.observe(.value) { [weak self] (snapshot) in
            
            guard let strongeSelf = self else { return }
            
            for item in snapshot.children {
                
                guard let details = item as? DataSnapshot else { return }
                
                if let profileModel = ProfileModel(details),profileModel.profileId != strongeSelf.currentProfileId {
                    
                    strongeSelf.friendList.insert(profileModel, at: 0)
                        
                }
            }
    
            strongeSelf.loadProfileManager()
            
        }
    
    }
    
    
    private func loadProfileManager(){
        
        ProfileManager.colloection.child(currentProfileId).observe(.value) { [weak self] (snapshot) in
            
            guard let strongeSelf = self else { return }
            
            for item in snapshot.children {
                
                guard let snapshot = item as? DataSnapshot else { continue }
                
                if let profileManager = ProfileManager(snapshot) {
                    
                    for getAllProfile in strongeSelf.friendList {
                        
                        guard let profile = getAllProfile as? ProfileModel else { return }
                        
                        if profileManager.profileId == profile.profileId {
                            
                            strongeSelf.friendList.remove(profile)
                            
                        }
                    }
                }
            }
            
            DispatchQueue.main.async {
                
                strongeSelf.friendsTableView.reloadData()
                
            }
        }
    }

}

extension AllFriendsTableViewController : UITableViewDelegate,UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return friendList.count
    
     }

        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let friendCell = tableView.dequeueReusableCell(withIdentifier: "AllFriendView", for: indexPath) as! FriendsViewCell
        
        let profileData = friendList[indexPath.row] as! ProfileModel
        
        friendCell.profileNameLabel.text = "\(profileData.firstName) \(profileData.lastName)"
        
        if let profileImageURL = profileData.profileImage{
            
            friendCell.profileImage.sd_cancelCurrentImageLoad()
            
            friendCell.profileImage.sd_setImage(with: profileImageURL, completed: nil)

        }
        
        friendCell.localizationResouce = localizationResouce
        
        friendCell.selectedProfileId = profileData.profileId
        
        friendCell.setButtonTitle()
        
        return friendCell
    }

}
