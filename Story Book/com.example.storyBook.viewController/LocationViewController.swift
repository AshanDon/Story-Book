//
//  LocationViewController.swift
//  Story Book
//
//  Created by Ashan Don on 8/15/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

import MapKit

import GooglePlaces

class LocationViewController: UIViewController{
    
    public var localizationResouce : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @objc private func cancelButtonPressed(){
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc private func pressedCurrentLocation(){
        
    }

}

extension LocationViewController : GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    print("Place name: \(String(describing: place.name))")
//    print("Place ID: \(place.placeID)")
//    print("Place attributions: \(place.attributions)")
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
