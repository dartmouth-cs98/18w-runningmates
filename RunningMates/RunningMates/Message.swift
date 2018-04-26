//
//  Message.swift
//  RunningMates
//
//  Created by Sara Topic on 19/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
class Message {
    
    
    var messageText: String?
    var sentBy: String?
    var time: String?
    var ChatID: String?

    init(messageText: String?,sentBy: String?,time: String?,ChatID: String?){
        
        self.messageText = messageText 
        self.sentBy = sentBy
        self.time = time
        self.ChatID = ChatID
    
    }
    
    
    init?(json: [String: Any]) {
        let messageText = json["message"] as! String?
        let sentBy = json["sentBy"] as! String?
        let ChatID = json["chatID"] as! String?
        let time = json["time"] as! String?

        self.messageText = messageText
        self.sentBy = sentBy
        self.ChatID = ChatID
        self.time = time
    }
    
}
