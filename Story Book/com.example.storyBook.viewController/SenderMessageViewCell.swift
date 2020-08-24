//
//  SenderMessageViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/13/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class SenderMessageViewCell: UITableViewCell {

    @IBOutlet weak var senderMessageView: UIView!
    @IBOutlet weak var senderProfilePicture: UIImageView!
    @IBOutlet weak var sendMessageBody: UILabel!
    @IBOutlet weak var messageReportLabel: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //Edited on senderMessageView
        senderMessageView.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
