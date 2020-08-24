//
//  HomeViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/5/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var friendStoryCollectionView : UICollectionView!
    
    @IBOutlet weak var friendPostCollectionView : UICollectionView!
    
    public var localizeResouce : String?
    
    let data1 : [UIImage] = [UIImage(named: "Tabbar_Profile_Icon")!]
    
    let data2 : [UIImage] = [UIImage(named: "Tabbar_Profile_Icon")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let languageResouce = localizeResouce {
            
            setLanguageLocalization(languageResouce)
            
        }

        friendStoryCollectionView.delegate = self
        friendStoryCollectionView.dataSource = self
        
        friendPostCollectionView.delegate = self
        friendPostCollectionView.dataSource = self
        
        //Add Friends Story Xib File
        friendStoryCollectionView.register(UINib(nibName: "FriendStoryXib", bundle: nil), forCellWithReuseIdentifier: "FriendsStory")
        
        friendStoryCollectionView.register(UINib(nibName: "StoryProfileReusableView", bundle: nil), forCellWithReuseIdentifier: "ProfileReusableView")
        
        //Add Friends Post Xib File
        friendPostCollectionView.register(UINib(nibName: "FriendPostXib", bundle: nil), forCellWithReuseIdentifier: "FriendPost")
        
    }
    
    @IBAction func profileTabButtonDidTouch(_ sender: Any) {
        
        performSegue(withIdentifier: "HomeToProfile", sender: localizeResouce)
    }
    
    @IBAction func mediaTabButtonDidTouch(_ sender: Any) {
        
        performSegue(withIdentifier: "HomeToMedia", sender: localizeResouce)
        
        
    }
    
    @IBAction func notificationTabDidTouch(_ sender: Any) {
        
        performSegue(withIdentifier: "HomeToNotification", sender: localizeResouce)
        
    }
    
    @IBAction func chatListButtonDidTouch(_ sender: Any) {
        
        performSegue(withIdentifier: "HomeToChatList", sender: localizeResouce)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "HomeToProfile":
            
            guard let profileDestination = segue.destination as? ProfileViewController else {return }
            
            guard let senderValue = sender as? String else {return }
            
            profileDestination.localizationResouce = senderValue
            
            break
            
        case "HomeToMedia":
            
            guard let  mediaDestination = segue.destination as? MediaMainViewController else {return }
            
            guard let senderValue = sender as? String else {return }
            
            mediaDestination.localizaResouce = senderValue
            
            break
            
        case "HomeToNotification":
            
            guard let notificationDestination = segue.destination as? NotificationViewController else {return }
            
            guard let senderValue = sender as? String else {return }
            
            notificationDestination.localizaResouce = senderValue
            
            break
            
        case "HomeToChatList":
            
            guard let chatListDestination = segue.destination as? ChatListViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            chatListDestination.localizResouce = sendValue
            
            break
            
        default:
            break
        }
    }
    
    
    private func setLanguageLocalization(_ languageResouce : String){
        
        titleLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "HOME_TITLE")
        
    }
    
    @objc private func profileDidTouch(){
        
        let addStoryViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddStoryVC") as! AddStoryViewController
        
        addStoryViewController.localizationResouce = localizeResouce
        
        self.present(addStoryViewController, animated: true, completion: nil)
    }
    
}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.friendStoryCollectionView {
            
            return data1.count + 10
            
        } else {
            
            return data2.count
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.friendStoryCollectionView {
            
            let cellDetails = friendStoryCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendsStory", for: indexPath) as! FriendStoryCollectionViewCell
            
            return cellDetails
            
        } else {
            
            let cellDetails = friendPostCollectionView.dequeueReusableCell(withReuseIdentifier: "FriendPost", for: indexPath) as! FriendPostCollectionViewCell
            return cellDetails
            
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        if kind == UICollectionView.elementKindSectionHeader {
            
            let view = friendStoryCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ProfileReusableView", for: indexPath) as! StoryProfileReusableView
            
            let userId = Auth.auth().currentUser!.uid
            
            let userReference = ProfileModel.collection.child(userId)
            
            userReference.observe(.value) { [weak self] (snapshot) in
                
                guard let profileModel = ProfileModel(snapshot) else { return }
                
                guard let _ = self else { return }
                
                DispatchQueue.main.async {
                   
                    
                    if let profileImageURL = profileModel.profileImage {
                        
                        view.profileImage.sd_cancelCurrentImageLoad()
                        
                        view.profileImage.sd_setImage(with: profileImageURL, completed: nil)
                        
                    }
                
                }
            }
            
            // added tapGestureRecognizer in current profile image view
            
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileDidTouch))
            
            view.profileImage.isUserInteractionEnabled = true
            
            view.profileImage.addGestureRecognizer(gestureRecognizer)
            
            return view
        }
        fatalError("Unexpected kind")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(indexPath.row)
    }
    
}


