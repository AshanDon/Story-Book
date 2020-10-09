//
//  ProfileViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/7/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import FirebaseAuth

import FirebaseDatabase

import FirebaseStorage

import SDWebImage

class ProfileViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var myPostCollectionView: UICollectionView!
    
    @IBOutlet weak var postLabel: UILabel!
    
    @IBOutlet weak var followersLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var profileNameLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var followerCountLabel: UILabel!
    
    @IBOutlet weak var followerView : UIView!
    
    public var localizationResouce : String?
    
    private let imagePicker = UIImagePickerController()
    
    private var storageUploadTask : StorageUploadTask?
    
    private let userPostList : NSMutableArray = []
    
    lazy var progressIndicator : UIProgressView = {
        
        let _progressIndicator = UIProgressView()
        
        _progressIndicator.trackTintColor = UIColor.red
        
        _progressIndicator.progressTintColor = UIColor.orange
        
        _progressIndicator.progress = Float(0)
        
        _progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return _progressIndicator
        
    }()
    
    lazy var cancelButton : UIButton = {
       
        let _cancelButton = UIButton()
        
        if let languageResouce = localizationResouce {
            
            let cancelButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CANCEL_UPLOAD")
            
            _cancelButton.setTitle(cancelButtonTitle, for: .normal)
            
        }
        
        _cancelButton.setTitleColor(UIColor(named: "FriendPost_Border_Color"), for: .normal)
        
        _cancelButton.addTarget(self, action: #selector(cancelUploadPressed), for: .touchUpInside)
        
        _cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        return _cancelButton
        
    }()
    
    //Added the profileFeed proparty value from ProfileModel.
    
    var currentUserId : String {
        
        guard let userId = Auth.auth().currentUser?.uid else { return ""}
        
        return userId
        
    }
    
    var userProfileRef : DatabaseReference? {
        
        return ProfileModel.profileFeeds.child(currentUserId)
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let languageResouce = localizationResouce {
            
            setLanguageLocalization(languageResouce)
            
        }
        myPostCollectionView.delegate = self
        myPostCollectionView.dataSource = self
        
        myPostCollectionView.register(UINib(nibName: "MyPostXib", bundle: nil), forCellWithReuseIdentifier: "MyPostCell")
        
        loadProfileHeaderDetails()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageDidTouch))
        
        profileImageView.addGestureRecognizer(tapRecognizer)
        
        profileImageView.isUserInteractionEnabled = true
        
        imagePicker.delegate = self
        
        view.addSubview(progressIndicator)
        
        view.addSubview(cancelButton)
        
        let constraint : [NSLayoutConstraint] = [
            
            progressIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            
            progressIndicator.centerYAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            
            progressIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            progressIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cancelButton.centerXAnchor.constraint(equalTo: view.leftAnchor, constant: 60),
            
            cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 25)
        
        ]
        
        NSLayoutConstraint.activate(constraint)
        
        progressIndicator.isHidden = true
        
        cancelButton.isHidden = true
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        loadUserPost()
        
        getUserPostCount()
        
        getFollowerCount()
        
        let followeViewTGR = UITapGestureRecognizer(target: self, action: #selector(tapFollowerView))
        
        followerView.addGestureRecognizer(followeViewTGR)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshFollowerCount), name: NSNotification.Name("REFRESH_FOLLOWERS_COUNT"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name("REFRESH_FOLLOWERS_COUNT"), object: nil)
        
    }

    @IBAction func menuButtonDidTouch(_ sender: UIButton) {
        
        do {
            
            try Auth.auth().signOut()
            
            let loginStoryboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoginPage") as! LoginViewController
            
            present(loginStoryboard, animated: true, completion: nil)
            
        } catch let signOutError as NSError{
            print("signOut error \(signOutError)")
        }
        
    }
    
    @IBAction func homeTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizationResouce {
            
            performSegue(withIdentifier: "ProfileToHome", sender: languageResouce)
            
        }
        
    }
    
    @IBAction func mediaTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizationResouce {
            
            performSegue(withIdentifier: "ProfileToMedia", sender: languageResouce)
            
        }
    }
    
    @IBAction func notificationTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizationResouce {
            
            performSegue(withIdentifier: "ProfileToNotification", sender: languageResouce)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "ProfileToHome":
            
            guard let homeDestination = segue.destination as? HomeViewController else {return }
            
            guard let senderValue = sender as? String else {return }
            
            homeDestination.localizeResouce = senderValue
            
            break
            
        case "ProfileToMedia":
            
            guard let mediaDestination = segue.destination as? MediaMainViewController else {return }
            
            guard let senderValue = sender as? String else {return }
            
            mediaDestination.localizaResouce = senderValue
            
            break
        
        case "ProfileToNotification":
            
            guard let notificationDestination = segue.destination as? NotificationViewController else {return }
            
            guard let senderValue = sender as? String else {return }
            
            notificationDestination.localizaResouce = senderValue
            
            break
            
        default:
            break
        }
    }
    
    private func setLanguageLocalization(_ languageResouce : String ){
        
        postLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "POST_LABEL")
        
        followersLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "FOLLOWER_LABEL")
        
        followingLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "FOLLOWING_LABEL")
        
    }
    
    private func loadProfileHeaderDetails(){
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let userReference = ProfileModel.collection.child(userId)
        
        userReference.observe(.value) { [weak self] (snapshot) in
            
            guard let strongeSelf = self else { return }
            
            guard let profileModel = ProfileModel(snapshot) else { return }
            
            DispatchQueue.main.async {
               
                strongeSelf.profileNameLabel.text = "\(profileModel.firstName) \(profileModel.lastName)"
                
                if let profileImageURL = profileModel.profileImage {
                    
                    strongeSelf.profileImageView.sd_cancelCurrentImageLoad()
                    
                    strongeSelf.profileImageView.sd_setImage(with: profileImageURL, completed: nil)
                    
                }
                
            }

        }
        
    }
    
    @objc private func profileImageDidTouch(){
        
        var alertTitle = String()
        
        var alertMessage = String()
        
        var libraryAction = String()
        
        var takePhotoAction = String()
        
        var cancelAction = String()
        
        if let languageResouce = localizationResouce {
            
            alertTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CHANGE_PROFILE_TITLE")
            
            alertMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CHANGE_PROFILE_MESSAGE")
            
            libraryAction = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "LIBRARY_OPTION")
            
            takePhotoAction = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TAKEPHOTO_OPTION")
            
            cancelAction = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CANCEL_BUTTON")
            
        }
        
        
        let changePImageAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .actionSheet)
        
        let libraryOption = UIAlertAction(title: libraryAction, style: .default) { [weak self] (action) in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.imagePicker.isEditing = true
            
            strongeSelf.imagePicker.sourceType = .photoLibrary
            
            strongeSelf.present(strongeSelf.imagePicker, animated: true, completion: nil)
            
        }
        
        let takePhotoOption = UIAlertAction(title: takePhotoAction, style: .default) { [weak self](action) in
            
            guard let strongeSelf = self else { return }
            
            strongeSelf.imagePicker.isEditing = true
            
            strongeSelf.imagePicker.sourceType = .camera
            
            strongeSelf.present(strongeSelf.imagePicker, animated: true, completion: nil)
            
        }
        
        let cancelOption = UIAlertAction(title: cancelAction, style: .cancel) { (action) in
            
            changePImageAlert.dismiss(animated: true, completion: nil)
            
        }
        
        changePImageAlert.addAction(libraryOption)
        
        changePImageAlert.addAction(takePhotoOption)
        
        changePImageAlert.addAction(cancelOption)
        
        self.present(changePImageAlert, animated: true, completion: nil)
    }
    
    @objc private func cancelUploadPressed() {
        
        progressIndicator.isHidden = true
        
        cancelButton.isHidden = true
        
        storageUploadTask?.cancel()
        
    }
    
    private func uploadProfileImage(_ imageData : Data){
        
        if let user = Auth.auth().currentUser {
            
            progressIndicator.isHidden = false
            
            cancelButton.isHidden = false
            
            progressIndicator.progress = Float(0)
            
            let imageId : String = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
            
            let imageName = "\(imageId).jpg"
            
            let pathOfProfileImage = "profileImages/\(user.uid)/\(imageName)"
            
            let storageReference = Storage.storage().reference(withPath: pathOfProfileImage)
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/jpg"
            
            storageUploadTask = storageReference.putData(imageData, metadata: metaData, completion: { [weak self] (storageMetaData, error) in
                
                guard let strongeSelf = self else { return }
                
                DispatchQueue.main.async {
                    
                    strongeSelf.progressIndicator.isHidden = true
                    
                    strongeSelf.cancelButton.isHidden = true
                    
                }
                
                if let error = error {
                    
                    print(error.localizedDescription)
                    
                    if let languageResouce = strongeSelf.localizationResouce {
                        
                        let errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "UPLOADED_ERROR_TITLE")
                        
                        let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "UPLOADED_ERROR_MESSAGE")
                        
                        let okAction = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "OK_ALERT")
                        
                        
                        let errorAlert = Validation.errorAlert(errorTitle, errorMessage, okAction)
                        
                        DispatchQueue.main.async {
                            
                            strongeSelf.present(errorAlert, animated: true, completion: nil)
                            
                        }
                    }
                    
                } else {
                    
                    storageReference.downloadURL { (url, error) in
                        
                        if let url = url,error == nil {
                            
                            ProfileModel.collection.child(user.uid).updateChildValues(["profile_Image" : url.absoluteString])
                            
                        } else {
                            
                            if let languageResouce = strongeSelf.localizationResouce {
                                
                                let errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "UPLOADED_ERROR_TITLE")
                                
                                let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "UPLOADED_ERROR_MESSAGE")
                                
                                let okAction = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "OK_ALERT")
                                
                                
                                let errorAlert = Validation.errorAlert(errorTitle, errorMessage, okAction)
                                
                                DispatchQueue.main.async {
                                    
                                    strongeSelf.present(errorAlert, animated: true, completion: nil)
                                    
                                }
                            }
                            
                        }
                        
                    }
                    
                    
                
                }
            })
            
            storageUploadTask?.observe(.progress, handler: { [weak self] (snapshot) in
                
                guard let strongeSelf = self else { return }
                
                let completeProgress = 100.0 * Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                
                DispatchQueue.main.async {
                    
                    strongeSelf.progressIndicator.setProgress(Float(completeProgress), animated: true)
                    
                }
            })
        }
        
    }
    
    private func loadUserPost(){
        
        userProfileRef?.observe(.value, with: { [weak self] (snapshot) in
            
            guard let strongeSelf = self else { return }
            
            for getData in snapshot.children {
                
                guard let snapshot = getData as? DataSnapshot else { return }
                
                if let postModel = Post(snapshot) {
                    
                    strongeSelf.userPostList.insert(postModel, at: 0)
                    
                }
            }
            
            DispatchQueue.main.async {
                
                strongeSelf.myPostCollectionView.reloadData()
                
                strongeSelf.getUserPostCount()
            }
        })
        
    }
    
    private func getUserPostCount() {
        
        postCountLabel.text = "\(userPostList.count)"
        
        
    }
    
    private func getFollowerCount() {
        
        var followerCount : Int = 0
        
        ProfileManager.colloection.child(currentUserId).observeSingleEvent(of: .value) { [weak self] (snapshot) in
            
            guard let strongeSelf = self else { return }
            
            for data in snapshot.children {
                
                guard let snapshot = data as? DataSnapshot else { continue }
                
                guard let profileManager = ProfileManager(snapshot) else { continue }
                
                if (profileManager.status == "FOLLOW" || profileManager.status == "අනුගමනය කරන්න") {
                    
                    followerCount += 1
                    
                }
            }
            
            strongeSelf.followerCountLabel.text = "\(followerCount)"
            
        }
    
    }
    
    @objc private func tapFollowerView(){
        
        let followerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FOLLOWERS_VIEW") as! AllFollowersViewController
        
        followerVC.modalPresentationStyle = .pageSheet
        
        followerVC.modalTransitionStyle = .coverVertical
        
        followerVC.localizationResouce = localizationResouce
        
        self.present(followerVC, animated: true, completion: nil)
        
    }
    
    @objc private func refreshFollowerCount(){
        
        getFollowerCount()
        
    }

}

extension ProfileViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return userPostList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myPostCell = myPostCollectionView.dequeueReusableCell(withReuseIdentifier: "MyPostCell", for: indexPath) as! MyPostCollectionViewCell
        
        let post = userPostList[indexPath.row] as! Post
        
        DispatchQueue.main.async {
            
            if let imageURL = post.imageDownloadURL {
                
                myPostCell.myPostImageView.sd_cancelCurrentImageLoad()
                
                myPostCell.myPostImageView.sd_setImage(with: imageURL, completed: nil)
                
            }
            
        }
        return myPostCell
    }
}

extension ProfileViewController : UIImagePickerControllerDelegate {
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        
            if let imageData = pickedImage.pngData() {
                
                self.uploadProfileImage(imageData)

            }
            
        }
        
        dismiss(animated: true, completion: nil)
    }
}
