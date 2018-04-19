
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


class CustomMessageCell: UITableViewCell {
    @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
}

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let manager = SocketManager(socketURL: URL(string: "https://running-mates.herokuapp.com/")!)
//    let manager = SocketManager(socketURL: URL(string: "http://localhost:9090")!)

    var selectedChat: String = ""
    var chatID: String!
    var userEmail: String!
    private var chats: [Any] = [Any]()
    private var data = [Message]()  // list of chat objects with chat ID, other user's name
    // @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var toolbar: UIToolbar!


    @IBOutlet weak var tableView: UITableView!
//    self.tableView.rowHeight = UITableViewAutomaticDimension
//    self.tableView.estimatedRowHeight = 140
    @IBOutlet weak var chatInput: UITextField!
    //  @IBOutlet weak var sendButton: UIButton!

   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(data.count)
        return data.count
    }

    // function written with help from http://www.thomashanning.com/uitableview-tutorial-for-beginners/
    // and https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/#dynamic_data_contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("making a cell")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath)
//
//
//        cell.textLabel?.text = "hello"
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! CustomMessageCell

        let chat_text : String  = data[indexPath.row].messageText as! String

        cell.textView?.text = chat_text


        print("data in cell making func",  data[indexPath.row] )
        return cell

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


    func fetchChats(completion: @escaping ([Any])->()) {

        let url = appDelegate.rootUrl + "api/chats"

        let params: Parameters = [
            "user": self.userEmail
        ]

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

    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchChats(completion: { chats in
//            self.chats = chats
//            self.tableView.dataSource = self
//            self.tableView.reloadData()
//        })



        self.userEmail = appDelegate.userEmail
        let socket = manager.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            print("socket connected")
        }

            socket.on("chat message") {data, ack in
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
//
//        fetchChats(completion: { chats in
//            self.data = chats
//            self.tableView.dataSource = self
//            self.tableView.reloadData()
//        })
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

    }



    @IBAction func sendMessage(_ sender: Any) {
        print(self.chatInput.text!)

        print("email: " + String(describing: self.userEmail))
        
        var message : [String: Any]

        if (self.chatID != nil) {
            message = [
                "message": self.chatInput.text!,
                "sentBy": self.userEmail,
                "recipient": "drew@test.com",
                "chatID": self.chatID
                // "chatID" : "127489djkahd873dbiqehfwyryedhfsui"
            ]
        } else {
            message = [
                "message": self.chatInput.text!,
                "sentBy": self.userEmail,
                "recipient": "drew@test.com"
            ]
        }
        print(message)


        let socket = manager.defaultSocket
        socket.emit("chat message", message)
        self.chatInput.text = ""
    }

    func recieveMessage(message_data: [Any]){

        
        print("message recieved******")
        let message = message_data[0] as! [String:String]
        let message_to_display = Message(messageText: message["message"], sentBy: message["sentBy"], sentTo: appDelegate.userEmail, ChatID: "3420938423" )

        data.append(message_to_display);
    

        print("data array", data)
        self.tableView.reloadData()

    }

}
