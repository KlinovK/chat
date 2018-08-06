//
//  MessageCellTableViewCell.swift
//  devslopes-chat
//
//  Created by Константин Клинов on 8/6/18.
//  Copyright © 2018 Константин Клинов. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

   
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var messageLbl: UILabel!
    


    func configureCell(user: String, message: String) {
        userName.text = user
        messageLbl.text = message
    }



}
