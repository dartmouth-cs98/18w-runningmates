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
    var sentTo: String?
    var ChatID: String?

    init(messageText: String?,sentBy: String?,sentTo: String?,ChatID: String?){
        
        self.messageText = messageText 
        self.sentBy = sentBy
        self.sentTo = sentTo
        self.ChatID = ChatID
    
    }
}
