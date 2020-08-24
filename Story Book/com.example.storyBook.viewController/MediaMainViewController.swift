//
//  MediaMainViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/8/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import Photos

class MediaMainViewController: UIViewController {

    @IBOutlet weak var imageGalleryCollectionView: UICollectionView!
    @IBOutlet weak var mediaTitleLabel: UILabel!
    private let newPostViewController = NewPostViewController()
    
    public var localizaResouce : String?
    
    var images = [PHAsset]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let languageResouce = localizaResouce {
            
            setLanguageLocalization(languageResouce)
            
        }
        
        imageGalleryCollectionView.delegate = self
        imageGalleryCollectionView.dataSource = self
        
        imageGalleryCollectionView.register(UINib(nibName: "ImageGalleryXib", bundle: nil), forCellWithReuseIdentifier: "ImageGalleryCell")
        
        if PHPhotoLibrary.authorizationStatus() == .authorized {
            
            getImages()
            
        }
        else {
            
            PHPhotoLibrary.requestAuthorization { (status) in
                
                switch status {
                    
                case .authorized:
                    
                    DispatchQueue.main.async {
                        
                        self.getImages()
                        
                    }
                
                case .denied, .notDetermined, .restricted:
                    
                    return
                default:
                    break
                }
                
            }
            
        }
    }
    
    func getImages() {
        
        let assets = PHAsset.fetchAssets(with: PHAssetMediaType.image, options: nil)
        
        assets.enumerateObjects({ (object, count, stop) in
            
            // self.cameraAssets.add(object)
            self.images.append(object)
        })
        
        //In order to get latest image first, we just reverse the array
        self.images.reverse()
        
        // To show photos, I have taken a UICollectionView
        self.imageGalleryCollectionView.reloadData()
    }
    
    @IBAction func homeTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizaResouce {
            
            performSegue(withIdentifier: "MediaToHome", sender: languageResouce)
            
        }
        
    }
    
    @IBAction func profileTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizaResouce {
            
            performSegue(withIdentifier: "MediaToProfile", sender: languageResouce)
            
            
        }
        
    }
    
    @IBAction func notificationTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizaResouce {
            
            performSegue(withIdentifier: "MediaToNotification", sender: languageResouce)
            
        }
        
    }
    
    @IBAction func cameraButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizaResouce {
            
            print("Noti to media resouce is \(languageResouce)")
            
            performSegue(withIdentifier: "MediaToCapturedView", sender: languageResouce)
            
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "MediaToHome":
            
            guard let homeDestination = segue.destination as? HomeViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            homeDestination.localizeResouce = sendValue
            
            break
            
        case "MediaToProfile":
            
            guard let profileDestination = segue.destination as? ProfileViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            profileDestination.localizationResouce = sendValue
            
            break
            
        case "MediaToNotification":
            
            guard let notificationDestination = segue.destination as? NotificationViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            notificationDestination.localizaResouce = sendValue
            
            break
            
        case "MediaToCapturedView":
            
            guard let capturedViewDestination = segue.destination as? CaptureViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            capturedViewDestination.localizResouce = sendValue
            
            break
            
        default:
            break
        }
    }
    
    private func setLanguageLocalization(_ languageRessouce : String){
        
        mediaTitleLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageRessouce, identification: "MEDIA_TITLE")
        
    }
    
    private func presentNewPostView(_ selectedImageData : Data){
        
        guard let newPostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "NewPost") as? NewPostViewController else {return }
        
        newPostVC.capturedImage = selectedImageData
        
        newPostVC.localizResoce = localizaResouce
        
        present(newPostVC, animated: true, completion: nil)
        
    }
}

extension MediaMainViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let galleryImageCell = imageGalleryCollectionView.dequeueReusableCell(withReuseIdentifier: "ImageGalleryCell", for: indexPath) as! ImageGalleryCollectionViewCell
        
        let asset = images[indexPath.row]
        
        let manager = PHImageManager.default()
        
        if galleryImageCell.tag != 0 {
            manager.cancelImageRequest(PHImageRequestID(galleryImageCell.tag))
        }
        
        galleryImageCell.tag = Int(manager.requestImage(for: asset,
                                            targetSize: CGSize(width: 120.0, height: 120.0),
                                            contentMode: .aspectFill,
                                            options: nil) { (result, _) in
                                                galleryImageCell.imageView?.image = result
        })
        
        return galleryImageCell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width = self.view.frame.width * 0.32

        let height = self.view.frame.height * 0.179910045

        return CGSize(width: width, height: height)

    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 2.5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var imageData = Data()
        
        let selectedRow = images[indexPath.row]
        
        let manager = PHImageManager.default()
        
        manager.requestImage(for: selectedRow,
                             targetSize: CGSize(width: 0, height: 0),
                             contentMode: .default,
                             options: nil)
        { (image, _) in
                                
            if let selectedImage = image {
                
                imageData = selectedImage.pngData()! as Data
                                
            }
        }
        
        self.presentNewPostView(imageData)
    }
    
}
