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
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet var editButton : UIBarButtonItem!
    
    public var localizationResouce : String?
    
    public var tagPeopleList : [String]?
    
    private var nameList = ["Ashan Anuruddika","Dasun Maduwantha","Terance Wijesuriya"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personTableView.isEditing = false
        
        if let languageResouce = localizationResouce {
            
            let navigationTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "TAG_PEOPLE")
            
            let cancelButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "BACK_BUTTON")
            
            
            
            let navigationItem = UINavigationItem(title: navigationTitle)
            
            let cancelButton = UIBarButtonItem(title: cancelButtonTitle, style: .plain, target: self, action: #selector(cancelButtonPressed))
            
            
            
            navigationItem.leftBarButtonItem = cancelButton
            
            
            
            if let peopleNameList = tagPeopleList {
                
                if peopleNameList.count > 0 {
                    
                    let editButtonTitle = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "Edit_BUTTON")
                    
                    editButton!.title = editButtonTitle
                    
                    editButton!.style = .plain
                    
                    editButton!.target = self
                    
                    editButton!.action = #selector(editButtonPressed)
                    
                    //let editButton = UIBarButtonItem(title: editButtonTitle, style: .plain, target: self, action: #selector(editButtonPressed))
                    
                    navigationItem.rightBarButtonItem = editButton
                    
                    
                }
                
            }
            
            navigationBar.setItems([navigationItem], animated: true)
            
            friendSearchField.placeholder = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "FRIEND_SEARCH_FIELD")
            
        }
        
        personTableView.register(UINib(nibName: "FindPeopleCell", bundle: nil), forCellReuseIdentifier: "PeopleCell")
        
        personTableView.dataSource = self
        
        personTableView.delegate = self
        
        personTableView.allowsSelectionDuringEditing = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "RELOAD_TAG_PEOPLE"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "REMOVE_TAG_PEOPLE"), object: nil)
        
    }
    
    @objc func cancelButtonPressed() {
        
        self.dismiss(animated: true) {
             
        }
        
    }
    
    @objc func editButtonPressed(){
        
        
        if let languageResouce = localizationResouce {
            
            if editButton.title!.elementsEqual("Edit") || editButton.title!.elementsEqual("සංස්කරණය"){
                
                editButton.title = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "DONE_BARBUTTON_ITEM")
                
                personTableView.isEditing = true
                
            } else {
                
                editButton.title = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "Edit_BUTTON")
                
                personTableView.isEditing = false
                
            }
            
            editButton.action = #selector(editButtonPressed)
            
        }
        
    }
    
}

extension FindPeopleViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return tagPeopleList!.count
            
        } else {
            
            return nameList.count
            
        }
        

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let peopleCell = personTableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! FindPeopleCell
            
            peopleCell.profileName.text = tagPeopleList![indexPath.row]
            
            return peopleCell
            
        } else {
            
            let peopleCell = personTableView.dequeueReusableCell(withIdentifier: "PeopleCell", for: indexPath) as! FindPeopleCell
            
            peopleCell.profileName.text = nameList[indexPath.row]
            
            return peopleCell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as! FindPeopleCell
            
            if let profileName = cell.profileName.text {
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "RELOAD_TAG_PEOPLE"), object: profileName)
                
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
    }
    
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//
//            tableView.beginUpdates()
//
//            tableView.deleteRows(at: [indexPath], with: .fade)
//
//            tagPeopleList!.remove(at: indexPath.row)
//
//            tableView.endUpdates()
//
//            tableView.reloadData()
//
//            NotificationCenter.default.post(name : Notification.Name(rawValue: "REMOVE_TAG_PEOPLE"),object: tagPeopleList)
//
//
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if indexPath.section == 0 {
            
            return true
            
        }
        
        return false
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if tagPeopleList!.count > 0, let languageResouce = localizationResouce {
            
            switch section {
                
            case 0:
                
                let firstSectionName = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "FIRSHT_TABLE_HEADER")
                
                return firstSectionName
                
            case 1:
                
                let secondSectionName = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "SECOND_TABLE_HEADER")
                
                return secondSectionName
                
            default:
                return ""
            }
            
        } else {
            
            return ""
            
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{

        var titleofButton = String()
        
        if let languageResouce = localizationResouce {
            
            titleofButton = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "DELETE_BUTTON")
            
        }
        
        let delete = UIContextualAction(style: .destructive, title: titleofButton) { [weak self] (action, view, completion ) in
            
            guard let strongeSelf = self else { return }

            tableView.beginUpdates()
            
            tableView.deleteRows(at: [indexPath], with: .fade)

            strongeSelf.tagPeopleList!.remove(at: indexPath.row)

            tableView.endUpdates()

            tableView.reloadData()

            NotificationCenter.default.post(name : Notification.Name(rawValue: "REMOVE_TAG_PEOPLE"),object: strongeSelf.tagPeopleList)

        }
        let config = UISwipeActionsConfiguration(actions: [delete])
        return config
    }
}
