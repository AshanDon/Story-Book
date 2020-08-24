//
//  ChatListViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/11/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {

    @IBOutlet weak var mainChatTableView: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var searchField: UITextField!
    
    public var localizResouce : String?
    
    private var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let languageResouce = localizResouce{
            
            setLanguageLocalization(languageResouce)
            
        }

        mainChatTableView.delegate = self
        mainChatTableView.dataSource = self
        
        mainChatTableView.register(UINib(nibName: "MainChatViewCell", bundle: nil), forCellReuseIdentifier: "MainChatCell")
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancelButtonDidTouch(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "ChatListToChatHeader":
            
            guard let chatHeaderDestination = segue.destination as? ChatHeaderViewController else {return }
            
            guard let sendValues = sender as? (String,UIImage) else {return }
            
            chatHeaderDestination.profileDetails = sendValues
            
            break
        default:
            break
        }
    }
    
    private func setLanguageLocalization(_ languageResouce : String){
        
        titleLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CHATLIST_TITLE")
        
        let search = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "CHATLIST_SEARCH")
        
        searchField.attributedPlaceholder = NSAttributedString(string: search ,attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "SignUp_TextFieldFont_Color")!])
        
    }
    
}

extension ChatListViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainChatCell = mainChatTableView.dequeueReusableCell(withIdentifier: "MainChatCell", for: indexPath) as! MainChatViewCell
        return mainChatCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let mainChatCell = mainChatTableView.dequeueReusableCell(withIdentifier: "MainChatCell", for: mainChatTableView.indexPathForSelectedRow!) as! MainChatViewCell
        
        let profileName = mainChatCell.profileNameLabel.text
        
        let profileImage = mainChatCell.profileImageView.image
        
        performSegue(withIdentifier: "ChatListToChatHeader", sender: (profileName!,profileImage))
        
    }
    
}
