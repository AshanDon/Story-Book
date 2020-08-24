//
//  ReceivingMessageViewCell.swift
//  Story Book
//
//  Created by Ashan Anuruddika on 6/12/20.
//  Copyright © 2020 Ashan. All rights reserved.
//

import UIKit

class ReceivingMessageViewCell: UITableViewCell {

    @IBOutlet weak var receivingMessageBody: UIView!
    @IBOutlet weak var receiverProfileImage: UIImageView!
    @IBOutlet weak var receiverMessageLabel: UILabel!
    @IBOutlet weak var receivingTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Edited on Receiving Message Body
        receivingMessageBody.layer.cornerRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
