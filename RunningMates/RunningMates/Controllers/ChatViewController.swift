
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
//
//  FullChatViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 07/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
// http://www.thomashanning.com/uitableview-tutorial-for-beginners/
// https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/#dynamic_data_contents
// https://stackoverflow.com/questions/26207846/pass-data-through-segue
import UIKit
import Foundation
import Alamofire


class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let manager = SocketManager(socketURL: URL(string: "https://running-mates.herokuapp.com/")!)
    let manager = SocketManager(socketURL: URL(string: "http://localhost:9090")!)
    
    var selectedChat: String = ""
    var chatID: String!
    var userEmail: String!
    let recipientEmail : String = "drew@test.com"
    var sentByID : String = ""
    var recipientID : String = ""
    
    private var data = [Any]()  // list of chat objects with chat ID, other user's name
    // @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var toolbar: UIToolbar!
    
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatInput: UITextField!
    //  @IBOutlet weak var sendButton: UIButton!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // function written with help from http://www.thomashanning.com/uitableview-tutorial-for-beginners/
    // and https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/#dynamic_data_contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
        
        
        cell.textLabel?.text = "hello"
        
        //        let message = data[indexPath.row] as! [String:Any]
        //        let recipients: [String] = message["recipients"] as! [String]
        //
        //        var displayedMembers: String = ""
        //        displayedMembers += recipients[0]
        //
        //        for (index, recipient) in recipients.enumerated() {
        //            if (index != 0) {
        //                displayedMembers = displayedMembers + ", " + recipient
        //            }
        //        }
        //
        //cell.textLabel?.text = displayedMembers
        
        return cell
    }
    
    // function adapted from: https://stackoverflow.com/questions/26207846/pass-data-through-segue
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        print("selected a cell")
    //        // Create a variable that you want to send based on the destination view controller
    //        // You can get a reference to the data by using indexPath shown below
    //        let selectedObj = data[indexPath.row] as! [String: Any]
    //        self.selectedChat = selectedObj["id"] as! String
    //    }
    //
    // following function adapted from: https://stackoverflow.com/questions/44790227/pass-multiple-variables-through-segue-in-swift
    // passes id of the chat pressed to the chatViewController
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "chatPressed" {
    //            let cell = sender as? UITableViewCell
    //
    //            let index: IndexPath? = tableView?.indexPath(for: cell!)
    //            let selectedObj = data[(index?.row)!] as! [String: Any]
    //            let id: String = selectedObj["id"] as! String
    //
    //            let chatViewController = segue.destination as! ChatViewController
    //            chatViewController.chatID = id
    //        }
    //    }
    
    
    //    @IBOutlet var tableView: UITableView!
    //    var userId: String = ""
    //    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //var userEmail: String = ""
    //private var data: [Any] = [Any]()  // list of chat objects with chat ID, other user's name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
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
        
        //        view.bringSubview(toFront: toolbar)
        
        // https://stackoverflow.com/questions/29065219/swift-uitableview-didselectrowatindexpath-not-getting-called
        self.tableView.delegate = self
        self.tableView.dataSource = self
        //        self.userEmail = appDelegate.userEmail;
        

        let group = DispatchGroup()
        
        group.enter()
        group.enter()
        
        getUserId(email: self.userEmail, completion: {id in
            self.sentByID = id
            group.leave()
        })
        
        getUserId(email: self.recipientEmail, completion: {id in
            self.recipientID = id
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main) {
            self.fetchChats(completion: { chats in
                self.data = chats
                self.tableView.dataSource = self
                self.tableView.reloadData()
            })
        }
        
    }
    
    func fetchChats(completion: @escaping ([Any])->()) {
        print("i hate swift")
        
        //        let url = appDelegate.rootUrl + "api/chats"
        
        //        let params: Parameters = [
        //            "user": self.userEmail
        //        ]
        //
        //        let _request = Alamofire.request(url, method: .get, parameters: params)
        //            .responseJSON { response in
        //                switch response.result {
        //                case .success:
        //                    completion(response.result.value as! [Any])
        //                case .failure(let error):
        //                    let alert = UIAlertController(title: "Error Fetching Chats", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
        //                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        //                    self.present(alert, animated: true, completion: nil)
        //                    print(error)
        //                }
        //        }
        //        debugPrint("whole _request ****",_request)
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        print(self.chatInput.text!)
        
        print("email: " + String(describing: self.userEmail))
        
        var message : [String: Any] = [:]
            
        if (self.chatID != nil) {
            message = [
                "message": self.chatInput.text!,
                "sentBy": self.sentByID,
                "recipient": self.recipientID,
                "chatID": self.chatID
                // "chatID" : "127489djkahd873dbiqehfwyryedhfsui"
            ]
        } else {
            message = [
                "message": self.chatInput.text!,
                "sentBy": self.sentByID,
                "recipient": self.recipientID
            ]
        }
        print(message)
            
            
        let socket = self.manager.defaultSocket
        socket.emit("chat message", message)
        // self.textViewTemp.text.append(self.chatInput.text! + "\n")
        self.chatInput.text = ""

    }
    
    func recieveMessage(message_data: [Any]){
        print("message recieved")
        print(message_data[0])
        // https://stackoverflow.com/questions/29756722/cannot-invoke-append-with-an-argument-list-of-type-string
        guard let cur = message_data[0] as? String else { return }
        //   self.textViewTemp.text.append(cur)
        //  self.textViewTemp.text.append("\n")
    }
    
    
    private func loadSampleChats(){
        data.append("some message")
        self.tableView.reloadData()
        
        
        
        //  guard let chat1 = MessagePort() else {
        //    fatalError("Unable to instantiate meal1")
        //}
    }
    
    
    func getUserId(email: String, completion: @escaping (String)->()) {
        let rootUrl: String = appDelegate.rootUrl
        let url: String = rootUrl + "api/user/" + email
        
        let params : [String:Any] = [
            "email": email
        ]
        let _request = Alamofire.request(url, method: .get, parameters: params)
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let jsonUser = response.result.value as? [String:Any] {
                        do {
                            let user = try User(json: (jsonUser as [String:Any]))
                            if (user != nil) {
                                completion((user?.id)!)
                            } else {
                                print("nil")
                            }
                        } catch UserInitError.invalidId {
                            print("invalid id")
                        } catch UserInitError.invalidFirstName {
                            print("invalid first name")
                        } catch UserInitError.invalidLastName {
                            print("invalid last name")
                        } catch UserInitError.invalidImageURL {
                            print("invalid image url")
                        } catch UserInitError.invalidBio {
                            print("invalid bio")
                        } catch UserInitError.invalidGender {
                            print("invalid gender")
                        } catch UserInitError.invalidAge {
                            print("invalid age")
                        } catch UserInitError.invalidLocation {
                            print("invalid location")
                        } catch UserInitError.invalidEmail {
                            print("invalid email")
                        } catch UserInitError.invalidPassword {
                            print("invalid password")
                        } catch {
                            print("other error")
                        }
                    } else {
                        print("error creating user for user id")
                    }
                    
                case .failure(let error):
                    print("failure: error creating user for user id")
                    print(error)
                }
        }
    }
    
}

//class ChatViewController: UIViewController {
//
//    var chatID: String!
//    var userEmail: String!
//
////    @IBOutlet weak var chatView: UITableView!
//    @IBOutlet weak var chatInput: UITextField!
//    @IBOutlet weak var sendButton: UIButton!
//    @IBOutlet weak var textViewTemp: UITextView!
//
//
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let manager = SocketManager(socketURL: URL(string: "http://localhost:9090")!)
//
//    // source: https://nuclearace.github.io/Socket.IO-Client-Swift/faq.html
//    func addHandlers() {
//        let socket = manager.defaultSocket
//        socket.on("chat message") {data, ack in
//            self.recieveMessage(message_data: data)
//        }
//
//    }
//
//    func recieveMessage(message_data: [Any]){
//        print("message recieved")
//        print(message_data[0])
//        // https://stackoverflow.com/questions/29756722/cannot-invoke-append-with-an-argument-list-of-type-string
//        guard let cur = message_data[0] as? String else { return }
//        self.textViewTemp.text.append(cur)
//        self.textViewTemp.text.append("\n")
//
//    }
//
//
//    @IBAction func sendMessage(_ sender: Any) {
//        print(self.chatInput.text!)
//
//        print("email: " + String(describing: self.userEmail))
//        let message : [String: Any] = [
//            "message": self.chatInput.text!,
//            "sentBy": self.userEmail,
//            "recipient": "drew@test.com",
//            "chatID": self.chatID
//        ]
//
//        let socket = manager.defaultSocket
//        socket.emit("chat message", message)
//        self.textViewTemp.text.append(self.chatInput.text! + "\n")
//        self.chatInput.text = ""
//    }
//
//
//    // source: SocketIO docs (https://github.com/socketio/socket.io-client-swift/blob/master/README.md)
//    override func viewDidLoad() {
//
//        self.userEmail = appDelegate.userEmail
//        let socket = manager.defaultSocket
//
//        socket.on(clientEvent: .connect) {data, ack in
//        print("socket connected")
//        }
//
//        socket.on("chat message") {data, ack in
//            print("I AM HERE", data)
//            self.recieveMessage(message_data: data)
//        }
//
//        socket.connect()
//
//        if (self.chatID != nil) {
//            print("chat id: " + self.chatID)
//        }
//    }
//}
