//
//  SocketIOManager.swift
//  RunningMates
//
//  Created by Sudikoff Lab iMac on 5/2/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
// used the following tutorial: https://www.twilio.com/blog/2016/09/getting-started-with-socket-io-in-swift-on-ios.html

import SocketIO

class SocketIOManager: NSObject {
    static let instance = SocketIOManager()
//    var manager = SocketManager(socketURL: URL(string: "http://localhost:9090")!)
    var manager = SocketManager(socketURL: URL(string: "https://running-mates.herokuapp.com/")!)
    
    var socket : SocketIOClient
  
//    var socket = SocketIOClient(socketURL: URL(string: "http://localhost:9090")!)
    
    override init() {
        self.socket = manager.defaultSocket
        
        self.socket.on("message") {dataArray, ack in
            print("you got a message!")
            NotificationCenter.default
            .post(name: Notification.Name(rawValue: "messageNotification"), object: dataArray[0] as? [String: AnyObject])
        }
    }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func login(userID: String) {
        socket.emit("login", userID)
    }
    
    func logout(userID: String) {
        socket.emit("logout", userID)
    }
}
