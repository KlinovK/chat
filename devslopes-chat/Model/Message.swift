//
//  Message.swift
//  devslopes-chat
//
//  Created by Константин Клинов on 8/5/18.
//  Copyright © 2018 Константин Клинов. All rights reserved.
//

import Foundation

struct Message {
    fileprivate let _messageID: String
    fileprivate let _userID: String?
    fileprivate let _message: String?
    
    var messageID: String {
        return _messageID
    }
    var userID: String? {
        return _userID
    }

    var message: String? {
        return _message
    }

    init(messageID: String, messageData: Dictionary<String, AnyObject> ) {
        _messageID = messageID
        _userID = messageData["user"] as? String
        _message = messageData["message"] as? String
    }

    init(messageID: String, userID: String?, message: String?) {
        _messageID = messageID
        _userID = userID
        _message = message
    }
    
    static func messageArrayFromFBData(_ fbData: AnyObject) -> [Message] {
        var messages = [Message]()
        if let formatted = fbData as? Dictionary<String, AnyObject> {
            for (key, messageObj) in formatted {
                let obj = messageObj as! Dictionary<String, AnyObject>
                let message = Message(messageID: key, messageData: obj as Dictionary<String, AnyObject>)
                messages.append(message)
            }
        }
        return messages
    }
    
}
