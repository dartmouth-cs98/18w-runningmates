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

class ChatViewController: UIViewController {

    let manager = SocketManager(socketURL: URL(string: "http://localhost:9090")!, config: [.log(true), .connectParams(["token" : "ABC438s"])])
    var socket:SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket = manager.defaultSocket
        self.socket.connect();
    }

}

