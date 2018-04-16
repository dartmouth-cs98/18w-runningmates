//
//  ChatViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 30/03/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
//based on tutorial here: https://medium.com/@spiromifsud/realtime-updates-in-ios-swift-4-using-socket-io-with-mysql-and-node-js-de9ae771529

import UIKit
import SocketIO
//import Chatto
//import ChattoAdditions


class ChatViewController: UIViewController {

    var chatID: String!
    var userEmail: String!
    
//    @IBOutlet weak var chatView: UITableView!
    @IBOutlet weak var chatInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textViewTemp: UITextView!
    

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manager = SocketManager(socketURL: URL(string: "http://localhost:9090")!)
    
    // source: https://nuclearace.github.io/Socket.IO-Client-Swift/faq.html
    func addHandlers() {
        let socket = manager.defaultSocket
        socket.on("chat message") {data, ack in
            self.recieveMessage(message_data: data)
        }

    }

    func recieveMessage(message_data: [Any]){
        print("message recieved")
        print(message_data[0])
        // https://stackoverflow.com/questions/29756722/cannot-invoke-append-with-an-argument-list-of-type-string
        guard let cur = message_data[0] as? String else { return }
        self.textViewTemp.text.append(cur)
        self.textViewTemp.text.append("\n")

    }

    
    @IBAction func sendMessage(_ sender: Any) {
        print(self.chatInput.text!)
        
        print("email: " + String(describing: self.userEmail))
        let message : [String: Any] = [
            "message": self.chatInput.text!,
            "sentBy": self.userEmail,
            "recipient": "drew@test.com",
            "chatID": self.chatID
        ]
        
        let socket = manager.defaultSocket
        socket.emit("chat message", message)
        self.textViewTemp.text.append(self.chatInput.text! + "\n")
        self.chatInput.text = ""
    }

    
    // source: SocketIO docs (https://github.com/socketio/socket.io-client-swift/blob/master/README.md)
    override func viewDidLoad() {
   
        self.userEmail = appDelegate.userEmail
        let socket = manager.defaultSocket
        
        socket.on(clientEvent: .connect) {data, ack in
        print("socket connected")
        }
        
        socket.on("chat message") {data, ack in
            print("I AM HERE", data)
            self.recieveMessage(message_data: data)
        }
        
        socket.connect()
        
        if (self.chatID != nil) {
            print("chat id: " + self.chatID)
        }
    }
}

