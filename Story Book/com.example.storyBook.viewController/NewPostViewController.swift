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
