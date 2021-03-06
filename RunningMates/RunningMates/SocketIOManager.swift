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

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var manager: SocketManager?

    var socket : SocketIOClient

    override init() {
        manager = SocketManager(socketURL: URL(string: appDelegate.rootUrl)!)
        self.socket = manager!.defaultSocket

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
        print("LOGGING IN")
        socket.emit("login", userID)
    }

    func logout(userID: String) {
        socket.emit("logout", userID)
    }
}
