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

//    @IBOutlet weak var chatView: UITableView!
    @IBOutlet weak var chatInput: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textViewTemp: UITextView!
    
   
    
    let manager = SocketManager(socketURL: URL(string: "http://localhost:9090")!)
    
    
    // source: https://nuclearace.github.io/Socket.IO-Client-Swift/faq.html
    func addHandlers() {
        manager.defaultSocket.on("chat message") {data, ack in
            print(data)
        }
    }

    @IBAction func sendMessage(_ sender: Any) {
        print(self.chatInput.text!)
        let socket = manager.defaultSocket
        socket.emit("chat message", [self.chatInput.text!])
        self.textViewTemp.text.append(self.chatInput.text! + "\n")
        self.chatInput.text = ""
 
        //textViewTemp.text = "\n"
        //self.chatInput.text = ""

    }
    
    
    // source: SocketIO docs (https://github.com/socketio/socket.io-client-swift/blob/master/README.md)
    override func viewDidLoad() {
   
    let socket = manager.defaultSocket
    
    socket.on(clientEvent: .connect) {data, ack in
    print("socket connected")
    }
    
    socket.on("currentAmount") {data, ack in
    guard let cur = data[0] as? Double else { return }
    
    socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
    socket.emit("update", ["amount": cur + 2.50])
    }
    
    ack.with("Got your currentAmount", "dude")
    }
    
    socket.connect()
    }

}

