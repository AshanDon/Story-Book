//
//  AllFollowersViewController.swift
//  Story Book
//
//  Created by Ashan Don on 10/5/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseAuth

import FirebaseDatabase

class AllFollowersViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var followersTable: UITableView!
    
    public var localizationResouce : String?
    
    private var followerList : NSMutableArray = []
    
    private var getCurrentUserId : String {
        
        guard let userId = Auth.auth().currentUser?.uid else { return ""}
        
        return userId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        followersTable.delegate = self

        followersTable.dataSource = self
        
        if let languageLocalization = localizationResouce {
            
            let navigationBarTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageLocalization, identification: "FOLLOWER_LABEL")
            
            let backButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageLocalization, identification: "CANCEL_BARBUTTON_ITEM")
            
            let navigationItem = UINavigationItem(title: navigationBarTitle)
            
            let backButton = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: #selector(backButtonDidTouch))
            
            navigationItem.leftBarButtonItem = backButton
            
            navigationBar.setItems([navigationItem], animated: true)
            
            followersTable.register(UINib(nibName: "FriendsViewCell", bundle: nil), forCellReuseIdentifier: "AllFriendView")
            
            getFollowerDetails()
            
            NotificationCenter.default.addObserver(self, selector: #selector(refreshTable(_:)), name: NSNotification.Name("REFRESH_TABLE"), object: nil)
            
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("REFRESH_TABLE"), object: nil)
        
        NotificationCenter.default.post(name: Notification.Name("REFRESH_FOLLOWERS_COUNT"), object: nil)
        
    }
    
    private func getFollowerDetails() {
        
        ProfileManager.colloection.child(getCurrentUserId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongeSelf = self else { return }
            
            for item in snapshot.children{
                
                guard let snapshot = item as? DataSnapshot else { continue }
                
                if let profileManager = ProfileManager(snapshot) {
                    
                    if profileManager.status == "FOLLOW" {
                        
                        strongeSelf.loadProfileDetails(profileManager.profileId)
                
                    }
                    
                }
            }
            
        }
    }
    
    private func loadProfileDetails(_ profileId : String){
        
        ProfileModel.collection.observeSingleEvent(of: .value) { [weak self] (profileModelSnapshot) in
            
            guard let strongeSelf = self else { return }
            
            for item in profileModelSnapshot.children {
                
                guard let snapshot = item as? DataSnapshot else { continue }
                
                guard let profileModel = ProfileModel(snapshot) else { return }
                
                if profileModel.profileId == profileId {
                    
                    strongeSelf.followerList.insert(profileModel, at: 0)
                    
                }
                
            }
            
            DispatchQueue.main.async {

                strongeSelf.followersTable.reloadData()
                
            }
        }
        
    }
    
    @objc private func backButtonDidTouch(){

        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func refreshTable(_ notification : Notification){
        
        guard let unfollowId = notification.object as? String else { return }
        
        for list in followerList {
            
            guard let followerDetail = list as? ProfileModel else { return }
            
            if followerDetail.profileId.elementsEqual(unfollowId) {
                
                followerList.remove(followerDetail)
                
            }
        }
        
        DispatchQueue.main.async {

            self.followersTable.reloadData()
            
        }
        
    }
    
}

extension AllFollowersViewController : UITableViewDelegate,UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return followerList.count
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let followerCell = followersTable.dequeueReusableCell(withIdentifier: "AllFriendView", for: indexPath) as! FriendsViewCell
        
        let followerCellData = followerList[indexPath.row] as! ProfileModel
        
        if let profileImage = followerCellData.profileImage {
            
            followerCell.profileImage.sd_cancelCurrentImageLoad()
            
            followerCell.profileImage.sd_setImage(with: profileImage, completed: nil)
            
        }
        
        followerCell.profileNameLabel.text = "\(followerCellData.firstName) \(followerCellData.lastName)"
        
        followerCell.localizationResouce = localizationResouce
        
        followerCell.selectedProfileId = followerCellData.profileId
        
        followerCell.setUnfollowTitle()
        
        return followerCell
        
    }


}
