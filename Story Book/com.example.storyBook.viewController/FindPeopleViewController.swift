//
//  FindPeopleViewController.swift
//  Story Book
//
//  Created by Ashan Don on 8/30/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class FindPeopleViewController: UIViewController {

    @IBOutlet weak var friendSearchField: UISearchBar!
    
    @IBOutlet weak var personTableView: UITableView!
    
    public var localizationResouce : String?
    
    private var Created a list "nameList" and assigned values for testing. = ["Ashan Anuruddika","Dasun Maduwantha","Terance Wijesuriya"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Created the navigation bar and configuration to the navigation item

        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        
        if let languageResouce = localizationResouce {
            
            let navigationTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TAG_PEOPLE")
            
            let cancelButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "BACK_BUTTON")
            
            let doneButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "NEXT_BUTTON")
            
            let navigationItem = UINavigationItem(title: navigationTitle)
            
            let cancelButton = UIBarButtonItem(title: cancelButtonTitle, style: .plain, target: self, action: #selector(cancelButtonPressed))
            
            let doneButton = UIBarButtonItem(title: doneButtonTitle, style: .plain, target: self, action: #selector(doneButtonPressed))
            
            navigationItem.leftBarButtonItem = cancelButton
            
            navigationItem.rightBarButtonItem = doneButton
            
            navigationBar.setItems([navigationItem], animated: true)
            
            friendSearchField.placeholder = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "FRIEND_SEARCH_FIELD")
            
        }
        
        view.addSubview(navigationBar)
        
        personTableView.register(UINib(nibName: "FindPeopleCell", bundle: nil), forCellReuseIdentifier: "PeopleCell")
        
        personTableView.dataSource = self
        
        personTableView.delegate = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "RELOAD_TAG_PEOPLE"), object: nil)
        
    }
    
    @objc func cancelButtonPressed() {
        
        self.dismiss(animated: true) {
             
        }
        
    }
    
    @objc func doneButtonPressed(){
        
    }

}

extension FindPeopleViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return nameList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let peopleCell = personTableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! FindPeopleCell
        
        peopleCell.profileName.text = nameList[indexPath.row]
        
        return peopleCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FindPeopleCell
        
        if let profileName = cell.profileName.text {
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "RELOAD_TAG_PEOPLE"), object: profileName)
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
}
