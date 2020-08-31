//
//  NewPostViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 7/3/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import AVFoundation

import GooglePlaces

import FirebaseAuth

import FirebaseStorage

class NewPostViewController: UIViewController {

    @IBOutlet weak var mainTableView: UITableView!
    
    @IBOutlet weak var capturedView: UIView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var postTextView: UITextView!
    
    public var capturedImage : Data?
    
    public var capturedVideo : URL?
    
    public var localizResoce : String?
    
    private var avPlayer = AVPlayer()
    
    private var avPlayerLayer = AVPlayerLayer()
    
    public var capturedDelegate : CapturedManagerDelegate?
    
    private var storageUploadTask : StorageUploadTask?
    
    private var tagPepoleList = [String]()
    
    //Created a TouchView
    lazy var touchView : UIView = {
        
        let _touchView = UIView()
        
        _touchView.backgroundColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 0)
        
        _touchView.isUserInteractionEnabled = true
        
        _touchView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        _touchView.addGestureRecognizer(tapGestureRecognizer)
        
        return _touchView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //added Selected language in this View.
        setLanguageLocalization()
        
        mainTableView.delegate = self
        
        mainTableView.dataSource = self

        mainTableView.register(UINib(nibName: "TagPeopleTableViewCell", bundle: nil), forCellReuseIdentifier: "TAGPEOPLE")
        
        mainTableView.register(UINib(nibName: "AddLocationViewCell", bundle: nil), forCellReuseIdentifier: "ADDLOCATION")
        
        if let image = capturedImage {
    
            let imageView = UIImageView(image: UIImage(data: image))
            
            imageView.frame = capturedView.bounds
            
            capturedView.addSubview(imageView)
            
        } else {
        
            avPlayerLayer = AVPlayerLayer(player: avPlayer)
            
            avPlayerLayer.frame = capturedView.bounds
            
            avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            capturedView.layer.insertSublayer(avPlayerLayer, at: 0)
            
            view.layoutIfNeeded()
            
            let vedioItem = AVPlayerItem(url: capturedVideo!)
            
            avPlayer.replaceCurrentItem(with: vedioItem)
            
            avPlayer.play()
            
            definesPresentationContext = true
            
        }
        
        tagPepoleList.append("Dasun")
        tagPepoleList.append("Terance")
        
        postTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(realoadTagPeopleRow(_:)), name: Notification.Name("RELOAD_TAG_PEOPLE"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Register from keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShow(notification :)), name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasHidden), name: UIWindow.keyboardDidHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Remove from keyboard notification
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardDidHideNotification, object: nil)
    }

    @objc private func keyboardWasShow(notification : Notification) {
        
        self.view.addSubview(touchView)
        
    }
    
    @objc private func keyboardWasHidden(){
    
        self.touchView.removeFromSuperview()
        
    }
    
    private func setLanguageLocalization(){

        backButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: localizResoce!, identification: "BACK_BUTTON"), for: .normal)
        
        titleLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: localizResoce!, identification: "NEWPOST_TITLE")
        
        shareButton.setTitle(LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: localizResoce!, identification: "SHARE_BUTTON"), for: .normal)
        
        postTextView.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: localizResoce!, identification: "WRITE_A_CAPTION")
        
    }
    
    @IBAction func cancelButtonDidTouch(_ sender: Any) {
        
        capturedDelegate?.hiddenPreviewImage()
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func realoadLocationRow(_ notification : Notification) {
        
        let location = notification.object as! String
        
        let indexPath = IndexPath(item: 0, section: 1)
        
        if let cell = mainTableView.cellForRow(at: indexPath) as? AddLocationViewCell {
        
            cell.setSelectPlace(location)
        
        }
    }
    
    @objc private func realoadTagPeopleRow(_ notification : Notification) {
        
        let details = notification.object as! String
        
        tagPepoleList.append(details)
        
        let indexPath = IndexPath(row: 0, section: 0)

        if let cell = mainTableView.cellForRow(at: indexPath) as? TagPeopleTableViewCell {
            
            var nameList : String?
            
            for tagNames in tagPepoleList {

                if nameList == nil {
                    
                    nameList = tagNames
                    
                } else {
                    
                    nameList = "\(nameList!),\(tagNames)"
                    
                }

            }
            
            cell.tagPeopleLable.text = nameList!
    
        }
        
    }
    
    
    @IBAction func shareButtonDidTouch() {
        
        uploadNewPost()
        
    }
    
    
    
    private func uploadNewPost(){
        
        guard let captureImageData = capturedImage else { return }
        
        guard var caption = postTextView.text else { return }
        
        if let user = Auth.auth().currentUser {
            
            let imageId : String = UUID().uuidString.lowercased().replacingOccurrences(of: "-", with: "_")
            
            let imageName = "\(imageId).jpg"
            
            let pathOfPostImage = "postImage/\(user.uid)/\(imageName)"
            
            let storageReference = Storage.storage().reference(withPath: pathOfPostImage)
            
            let metaData = StorageMetadata()
            
            metaData.contentType = "image/jpg"
            
            storageUploadTask = storageReference.putData(captureImageData, metadata: metaData, completion: { [weak self] (storageMetaData, error) in
                
                guard let strongeSelf = self else { return }
                
                if let error = error {
                    
                    print(error.localizedDescription)
                    
                    if let languageResouce = strongeSelf.localizResoce {
                        
                        let errorTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "UPLOADED_ERROR_TITLE")
                        
                        let errorMessage = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "UPLOADED_ERROR_MESSAGE")
                        
                        let okAction = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "OK_ALERT")
                        
                        
                        let errorAlert = Validation.errorAlert(errorTitle, errorMessage, okAction)
                        
                        DispatchQueue.main.async {
                            
                            strongeSelf.present(errorAlert, animated: true, completion: nil)
                            
                        }
                    }
                    
                } else {
                    
                    storageReference.downloadURL { [weak self] (url, error) in
                        
                        guard let strongSelf = self else { return }
                        
                        if let url = url,error == nil {
                            
                            let locationCellIndexPath = IndexPath(item: 0, section: 1)
                            
                            if let cell = strongeSelf.mainTableView.cellForRow(at: locationCellIndexPath) as? AddLocationViewCell {
                                
                                guard var locationName = cell.addLocationLabel.text else { return }
                                
                                if locationName.elementsEqual("ස්ථානය එක් කරන්න") || locationName.elementsEqual("Add Location") {
                                    
                                    locationName = ""
                                    
                                }
                                
                                if caption.elementsEqual("Write a caption...") || caption.elementsEqual("පෝස්ට් එකේ කතාවක් ලියන්න"){
                                    
                                    caption = ""
                                    
                                }
                                
                                Post.newPost(userId: user.uid, caption: caption, imageDownloadURL: url.absoluteString, location: locationName, tagPepole: strongSelf.tagPepoleList)
                                
                                strongeSelf.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                            }
                            
                        } else {
                            
                            if let languageResouce = strongeSelf.localizResoce {
                                
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
            
        }
    
    }
    
    @objc private func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
}

extension NewPostViewController : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            
            return 1
            
        } else {
            
            return 1
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let tagPeopleCell = mainTableView.dequeueReusableCell(withIdentifier: "TAGPEOPLE",for: indexPath) as! TagPeopleTableViewCell
            
            tagPeopleCell.setLanguageLocalization(resouce: localizResoce!)
            
            return tagPeopleCell
            
        } else {
            
            let addLocationCell = mainTableView.dequeueReusableCell(withIdentifier: "ADDLOCATION",for: indexPath) as! AddLocationViewCell
            
            addLocationCell.setLanguageLocalization(resouce: localizResoce!)
            
            return addLocationCell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 {
            
            let tagPeopleVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "TagPeopleList") as! FindPeopleViewController

            tagPeopleVC.localizationResouce = localizResoce

            
            present(tagPeopleVC, animated: true,completion: nil)

        } else {
            
            let autocompleteController = GMSAutocompleteViewController()
            
            autocompleteController.tableCellBackgroundColor = UIColor.black
            
            autocompleteController.delegate = self

            // Specify the place data types to return.
            let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))!
            
            autocompleteController.placeFields = fields

            // Specify a filter.
            let filter = GMSAutocompleteFilter()
            
            filter.type = .city
            
            autocompleteController.autocompleteFilter = filter

            // Display the autocomplete view controller.
            
            NotificationCenter.default.addObserver(self, selector: #selector(realoadLocationRow(_ :)), name: Notification.Name("RELOADLOCATION"), object: nil)
            
            present(autocompleteController, animated: true, completion: nil)
            
        }
    }
    
}

extension NewPostViewController : GMSAutocompleteViewControllerDelegate {

  //Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    
    
    if let selectName = place.name {
    
        NotificationCenter.default.post(name: Notification.Name("RELOADLOCATION"), object: selectName)
        
    }

    
    NotificationCenter.default.removeObserver(self, name: Notification.Name("RELOADLOCATION"), object: nil)
    
    dismiss(animated: true, completion: nil)
    
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
    
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    
    dismiss(animated: true, completion: nil)
    
  }

}

extension NewPostViewController : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text.elementsEqual("Write a caption...") || textView.text.elementsEqual("පෝස්ට් එකේ කතාවක් ලියන්න"){
            
            postTextView.text = ""
            
            return false
            
        }
        
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if(text == "\n") {
            
            textView.resignFirstResponder()
            
            return false
            
        }
        
        return true
    }
    
}
