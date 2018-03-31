//
//  SocketIOManager.swift
//  RunningMates
//
//  Created by Sara Topic on 30/03/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

//based on this tutorial: https://appcoda.com/socket-io-chat-app

import UIKit
import SocketIO

class SocketIOManager: NSObject {
    static let sharedInstance = SocketIOManager()

  
    override init() {
        super.init()
    }
    
    var socket = SocketManager(socketURL: URL(string: "http://localhost:9090")!, config: [.log(true), .compress])

    

    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
    
}
