//
//  DataService.swift
//  devslopes-chat
//
//  Created by Константин Клинов on 8/5/18.
//  Copyright © 2018 Константин Клинов. All rights reserved.
//

import Foundation
import Firebase

protocol DataServiceDelegate: class {
    func dataLoaded()
}

class DataService {
    static let instance = DataService()
    
    let ref = Database.database().reference()
    var message: [Message] = []
    
    weak var delegate: DataServiceDelegate?
    
    func loadMessages(_ completion: @escaping (_ Success :Bool) -> Void) {
        ref.observe(.value) { (data: DataSnapshot) in
            if data.value !=  nil {
                let unsortedMessages = Message.messageArrayFromFBData(data.value! as AnyObject)
                self.message = unsortedMessages.sorted(by: {$0.messageID < $1.messageID})
                self.delegate?.dataLoaded()
                if self.message.count > 0 {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func saveMessage(_ user: String, message: String){
        let key = ref.childByAutoId().key
        let message = ["user": user,
            "message": message
        ]
        let messageUpdates = ["/\(key)": message]
        ref.updateChildValues(messageUpdates)
    }
    
}
