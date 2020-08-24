//
//  ChatHeaderViewController.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/11/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class ChatHeaderViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageBodyTableView: UITableView!
    
    public var profileDetails : (String,UIImage)?
    
    var dataArray : [String] = ["Receiving:Hi","Sender:Hi.","Receiving:How are you bro?","Sender:I am fine to thank you bro, and you?","Receiving:I am fine than you.","Receiving:A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument.","Sender:A paragraph is a series of related sentences developing a central idea, called the topic. Try to think about paragraphs in terms of thematic unity: a paragraph is a sentence or a group of sentences that supports one central, unified idea. Paragraphs add one idea at a time to your broader argument."]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Edited on Massage Text Field
        messageTextField.layer.cornerRadius = 15
        messageTextField.layer.borderColor = UIColor(named: "LoginView_TextFieldBorder_Color")!.cgColor
        messageTextField.layer.borderWidth = 2
        
        //added on delegate and data source form messageBodyTableView
        messageBodyTableView.delegate = self
        messageBodyTableView.dataSource = self
        
        // Added on Receiving Message Xib File from messageBodyTableView
        messageBodyTableView.register(UINib(nibName: "ReceivingMessageViewCell", bundle: nil), forCellReuseIdentifier: "ReceivingMessageCell")
        
        //Added on Sending Message Xib File from messageBodyTableView
        messageBodyTableView.register(UINib(nibName: "SenderMessageViewCell", bundle: nil), forCellReuseIdentifier: "SenderMessgeCell")
        
        if let profileName = profileDetails?.0 , let profileImage = profileDetails?.1{
            
            profileNameLabel.text = profileName
            
            profileImageView.image = profileImage
            
        }
        
    }
    
    @IBAction func backButtonDidTouch(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatHeaderViewController : UITableViewDelegate,UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = dataArray[indexPath.row].split(separator: ":")[0]
        if cellIdentifier == "Receiving" {
            let receivingMessageCell = messageBodyTableView.dequeueReusableCell(withIdentifier: "ReceivingMessageCell", for: indexPath) as! ReceivingMessageViewCell
            receivingMessageCell.receiverMessageLabel.text = String(dataArray[indexPath.row].split(separator: ":")[1])
            return receivingMessageCell
        } else {
            let sendingMessageCell = messageBodyTableView.dequeueReusableCell(withIdentifier: "SenderMessgeCell", for: indexPath) as! SenderMessageViewCell
            sendingMessageCell.sendMessageBody.text = String(dataArray[indexPath.row].split(separator: ":")[1])
            return sendingMessageCell
        }
//        let sendingMessageCell = messageBodyTableView.dequeueReusableCell(withIdentifier: "SenderMessgeCell", for: indexPath) as! SenderMessageViewCell
//        sendingMessageCell.sendMessageBody.text = dataArray[indexPath.row]
//       // sendingMessageCell.messageReportLabel.text = "Sent"
//        return sendingMessageCell
        
    }
}
