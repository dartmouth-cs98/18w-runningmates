
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
  //  @IBOutlet weak var textView: UILabel!
    @IBOutlet weak var bubbleView: UIImageView!

    @IBOutlet weak var textView: UILabel!
    //@IBOutlet weak var textView: UIImageView!
    //@IBOutlet weak var bubbleView: UIImageView!
   // @IBOutlet weak var imgView: UIImageView!
   
    
    @IBOutlet weak var bubbleHeightConstraint: NSLayoutConstraint!
}




class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!

    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var myStupidView: UIView!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var manager: SocketManager?

    var selectedChat: String = ""
    var chatID: String!

    var sentByID : String = ""
    var recipientID : String = ""

    var imageURL: String!
    var recipientName: String!
    
    private var chats: [Any] = [Any]()
    private var data = [Message]()  // list of chat objects with chat ID, other user's name
    
    var pageNumber = 1


    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chatInput: UITextField!


   //https://stackoverflow.com/questions/33705371/how-to-scroll-to-the-exact-end-of-the-uitableview
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.data.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
 
    // function written with help from http://www.thomashanning.com/uitableview-tutorial-for-beginners/
    // and https://www.ralfebert.de/ios-examples/uikit
    //uitableviewcontroller/#dynamic_data_contents
    // CHAT BUBBLE FROM: https://github.com/robkerr/TutorialChatBubble/tree/master/TutorialMessageBubble/Assets.xcassets
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! CustomMessageCell
        let chat_text : String  = data[indexPath.row].messageText as! String
        cell.textView?.text = chat_text
    let messageUserID = data[indexPath.row].sentBy
        
   //  message to yourself
    if (messageUserID == self.sentByID) {
        let image = UIImage(named: "chat_bubble_sent")
    
        cell.bubbleView.image = image?
        .resizableImage(withCapInsets:
        UIEdgeInsetsMake(17, 21, 17, 21),
        resizingMode: .stretch)
         .withRenderingMode(.alwaysTemplate)
        // Fallback on earlier versions
        cell.bubbleView.tintColor = UIColor(red:255/255.0, green:196/255.0, blue:25/255.0, alpha: 1.0)
        cell.textView.textColor = UIColor.white

        cell.bubbleHeightConstraint.constant =  getStringHeight(mytext: chat_text, fontSize: cell.textView.font.pointSize, width: 310) + 15
    } else {
        let image = UIImage(named: "chat_bubble_received")
        cell.bubbleView.image = image?
        .resizableImage(withCapInsets:
        UIEdgeInsetsMake(17, 21, 17, 21),
        resizingMode: .stretch)
        .withRenderingMode(.alwaysTemplate)
        cell.textView.textColor = UIColor.black

        cell.bubbleView.tintColor = UIColor(red: 0.8, green: 0.8, blue:  0.8, alpha: 1.0)
        cell.bubbleHeightConstraint.constant =  getStringHeight(mytext: chat_text, fontSize: cell.textView.font.pointSize, width: 310) + 15

    }

        cell.textView.layoutMargins = UIEdgeInsetsMake(30, 30, 30, 30)
  
        return cell

    }


  
    func getStringHeight(mytext: String, fontSize: CGFloat, width: CGFloat)->CGFloat {
        
        let font = UIFont.systemFont(ofSize: fontSize)
        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping;
        let attributes = [NSAttributedStringKey.font:font,
                          NSAttributedStringKey.paragraphStyle:paragraphStyle.copy()]
        
        let text = mytext as NSString
        let rect = text.boundingRect(with: size,
                                     options:.usesLineFragmentOrigin,
                                     attributes: attributes,
                                     context:nil)
        return rect.size.height
    }
    
    func fetchChats(completion: @escaping ([Message])->()) {

        let url = appDelegate.rootUrl + "api/chatHistory"
        let userToken: String = UserDefaults.standard.string(forKey: "token")!
        
        let headers : [String:String] = [
            "Authorization": userToken,
            "Content-Type": "application/json"
        ]

        let params: Parameters = [
            "chatID": self.chatID,
            "pageNumber": self.pageNumber
        ]

        let _request = Alamofire.request(url, method: .get, parameters: params, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                if let jsonResult = response.result.value as? [[String:Any]] {
                    var msgsList : [Message] = []
                    for jsonMsg in jsonResult {
                        let msg = Message(json: (jsonMsg as? [String:Any])!)
                        if (msg != nil && msg?.messageText != "") {
                            msgsList.append(msg!)
                        } else {
                            print("nil")
                        }
                    }
                    completion(msgsList)
                }
                case .failure(let error):
                    print("failure")
                    print(error)
                }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .none
        
        // help from https://stackoverflow.com/questions/26070242/move-view-with-keyboard-using-swift?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

      //  self.tableView.rowHeight = UITableViewAutomaticDimension

        let url = URL(string: self.imageURL)
                if (url != nil) {
            let imgData = try? Data(contentsOf: url!)
            let image = UIImage(data: imgData!)
            self.userImageView.image = image
                    
            self.userImageView.layer.cornerRadius = self.userImageView.frame.size.width / 2;
            self.userImageView.clipsToBounds = true;
            self.userImageView.layer.borderWidth = 2.5;
            self.userImageView.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        
        }
        
        self.userLabel.text = self.recipientName
        
        manager = SocketManager(socketURL: URL(string: appDelegate.rootUrl)!)

        self.sentByID = UserDefaults.standard.string(forKey: "id")!
        let socket = manager!.defaultSocket

        socket.on(clientEvent: .connect) {data, ack in
            if (self.chatID != nil) {
                socket.emit("join room", self.chatID)
            }
        }

            socket.on("chat message") {data, ack in
                self.recieveMessage(message_data: data)
            }

        socket.connect()


        // https://stackoverflow.com/questions/29065219/swift-uitableview-didselectrowatindexpath-not-getting-called
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.fetchChats(completion: { chats in
            self.data = chats
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140

    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y = 0.0
        }
    }

    @IBAction func sendMessage(_ sender: Any) {

        dismissKeyboard()
        var message : [String: Any] = [:]

        if (self.chatID != nil) {
            message = [
                "message": self.chatInput.text!,
                "sentBy": self.sentByID,
                "recipient": self.recipientID,
                "chatID": self.chatID
            ]
        } else {
            message = [
                "message": self.chatInput.text!,
                "sentBy": self.sentByID,
                "recipient": self.recipientID
            ]
        }

        let socket = manager!.defaultSocket
        socket.emit("chat message", message)
        self.chatInput.text = ""

    }
    
   override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: self.view.window)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: self.view.window)
    
    }

    func recieveMessage(message_data: [Any]){

        let message = message_data[0] as! [String:String]
        let message_to_display = Message(messageText: message["message"], sentBy: message["sentBy"], time: message["time"], ChatID: "3420938423" )

        if(message_to_display.messageText != ""){
            data.append(message_to_display);

            self.tableView.reloadData()
            scrollToBottom()
        }

    }
}

