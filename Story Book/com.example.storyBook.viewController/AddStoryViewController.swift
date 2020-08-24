//
//  AddStoryViewController.swift
//  Story Book
//
//  Created by Ashan Don on 8/13/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import Photos

class AddStoryViewController: UIViewController {

    public var localizationResouce : String?
    
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var imageGalleryCollectionView: UICollectionView!
    
    var images = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a Navigation Bar and adding the item.
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        
        if let languageResouce = localizationResouce {
            
            let navigationBarTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "ADD_STORY")
            
            let navigationItem = UINavigationItem(title: navigationBarTitle)
            
            let cancelButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CANCEL_BUTTON")
            
            let cancelBarButton = UIBarButtonItem(title: cancelButtonTitle, style: .plain, target: self, action: #selector(canncelBarButtonDidTouch))
            
            navigationItem.leftBarButtonItem = cancelBarButton
            
            navigationBar.setItems([navigationItem], animated: false)
            
        }
        
        self.view.addSubview(navigationBar)

        //create a Tap Gesture Recognizar and implement the capture image view
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapCaptureImageView))
        
        cameraImageView.isUserInteractionEnabled = true
        
        cameraImageView.addGestureRecognizer(gestureRecognizer)
        
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
    
    private func getImages() {
        
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
    
    @objc private func canncelBarButtonDidTouch(){
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @objc private func tapCaptureImageView(){
        
        let captureVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CaptureVC") as! CaptureViewController
        
        captureVC.localizResouce = localizationResouce
        
        captureVC.addStoryVC = self
        
        present(captureVC, animated: true, completion: nil)
        
    }
    
    private func presentStoryPostVC(_ imageDate : Data){
        
        let storyPostVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "StoryPostVC") as! StoryPostViewController
        
        storyPostVC.localizationResouce = localizationResouce
        
        storyPostVC.storyImageData = imageDate
        
        self.present(storyPostVC, animated: true, completion: nil)
        
    }

}

extension AddStoryViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    
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
        
        
        let selectedRow = images[indexPath.row]
        
        let manager = PHImageManager.default()
        
        manager.requestImage(for: selectedRow,
                             targetSize: CGSize(width: 0, height: 0),
                             contentMode: .default,
                             options: nil)
        { (image, _) in
                                
            if let selectedImage = image {

                self.presentStoryPostVC(selectedImage.pngData()! as Data)

            }
        }
        
    }
    
}
