//
//  NotificationViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/8/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

protocol NotificationDelagete {
    
    func presentChatHeaderView(_ profileName : String,_ profileImage : UIImage)
    
}

class NotificationViewController: UIViewController {

    let data : [String] = ["Ashan Anuruddika like your photo.","Paulina Gayoso comment your photo.","Paulina Gayoso share your photo."]
    
    @IBOutlet weak var notificationTable: UITableView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public var localizaResouce : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let languageResouce = localizaResouce {
            
            setLanguageLocalization(languageResouce)
            
        }

        notificationTable.delegate = self
        notificationTable.dataSource = self
        
        notificationTable.register(UINib(nibName: "NotificationViewCell", bundle: nil), forCellReuseIdentifier: "NotificationCell")
        notificationTable.register(UINib(nibName: "FollowedNotificationViewCell", bundle: nil), forCellReuseIdentifier: "FollowedNotificationCell")
        notificationTable.register(UINib(nibName: "FollowingNotificationViewCell", bundle: nil), forCellReuseIdentifier: "FollowingNotificationCell")
    }
    
    @IBAction func homeTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizaResouce {
            
            performSegue(withIdentifier: "NotificationToHome", sender: languageResouce)
            
        }
        
    }
    
    @IBAction func profileTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizaResouce {
            
            performSegue(withIdentifier: "NotificationToProfile", sender: languageResouce)
            
        }
        
    }
    
    @IBAction func mediaTabButtonDidTouch(_ sender: Any) {
        
        if let languageResouce = localizaResouce {
            
            performSegue(withIdentifier: "NotificationToMedia", sender: languageResouce)
            
        }
        
    }
    
    private func setLanguageLocalization(_ languageResouce : String){
        
        titleLabel.text = LanguageLocalization.shared.genaretedLanguageLocalization(languageResouce: languageResouce, identification: "NOTIFICATION_TITLE")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
            
        case "NotificationToHome":
            
            guard let homeDestination = segue.destination as? HomeViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            homeDestination.localizeResouce = sendValue
            
            break
            
        case "NotificationToProfile":
            
            guard let profileDestination = segue.destination as? ProfileViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            profileDestination.localizationResouce = sendValue
            
            break
            
        case "NotificationToMedia":
            
            guard let mediaDestination = segue.destination as? MediaMainViewController else {return }
            
            guard let sendValue = sender as? String else {return }
            
            print("Notification View : \(sendValue)")
            mediaDestination.localizaResouce = sendValue
            
            break
            
        default:
            break
        }
    }

}

extension NotificationViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
             return data.count
        } else if section == 1 {
            return 2
        } else {
            return 1
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let notificationCell = notificationTable.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationViewCell
            
            notificationCell.notificationLabel.text = data[indexPath.row]
            
            return notificationCell
        } else if indexPath.section == 1 {
            
            let followedCell = notificationTable.dequeueReusableCell(withIdentifier: "FollowedNotificationCell", for: indexPath) as! FollowedNotificationViewCell
            
            return followedCell
        } else {
            
            let followingCell = notificationTable.dequeueReusableCell(withIdentifier: "FollowingNotificationCell", for: indexPath) as! FollowingNotificationViewCell
            
            followingCell.notificationDelagete = self
            
            return followingCell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
}

extension NotificationViewController : NotificationDelagete{
    
    func presentChatHeaderView(_ profileName: String, _ profileImage: UIImage) {
        
        guard let chatHeaderVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatHeader") as? ChatHeaderViewController else {return }
        
        chatHeaderVC.profileDetails = (profileName,profileImage)
        
        self.present(chatHeaderVC, animated: true, completion: nil)
        
    }
    
    
}
