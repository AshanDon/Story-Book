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
    
    private let tagPepoleList = [String]()
    
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
    
    private func uploadNewPost(){
        print("ok ok ok ")
        guard let captureImageData = capturedImage else { return }
        
        guard let caption = postTextView.text else { return }
        
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
                    
                    storageReference.downloadURL { (url, error) in
                        
                        if let url = url,error == nil {
                            
                            //ProfileModel.collection.child(user.uid).updateChildValues(["profile_Image" : url.absoluteString])
                            let locationCellIndexPath = IndexPath(item: 0, section: 1)
                            
                            if let cell = strongeSelf.mainTableView.cellForRow(at: locationCellIndexPath) as? AddLocationViewCell {
                            
                                if cell.addLocationLabel.text != "", let locationName = cell.addLocationLabel.text {
                                    print("location \(locationName)")
                                    Post.newPost(userId: user.uid, caption: caption, imageDownloadURL: url.absoluteString, location: locationName, tagPepole: strongeSelf.tagPepoleList)
                                }
                            
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
    
    @IBAction func shareButtonDidTouch() {
        
        uploadNewPost()
        
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
