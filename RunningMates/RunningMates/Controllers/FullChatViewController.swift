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


class ChatPreviewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentPreviewLabel: UILabel!
    
}


class FullChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedChat: String = ""
    var userID: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // function written with help from http://www.thomashanning.com/uitableview-tutorial-for-beginners/
    // and https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/#dynamic_data_contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! ChatPreviewCell
        
        let message = data[indexPath.row] as! [String:Any]
        let recipients: [String] = message["recipients"] as! [String]
        let content: String = message["mostRecentMessage"] as! String
        let time: String = message["lastUpdated"] as! String
        
        var displayedMembers: String = ""
        displayedMembers += recipients[0]
        
        for (index, recipient) in recipients.enumerated() {
            if (index != 0) {
                displayedMembers = displayedMembers + ", " + recipient
            }
        }
        
        let url = URL(string: message["imageURL"] as! String)
        let imgData = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch

        let image = UIImage(data: imgData!)
        cell.userImg.image = image
        
        cell.userImg.contentMode = UIViewContentMode.scaleAspectFit
//        cell.userImg.layoutIfNeeded()
        cell.userImg.layer.borderWidth = 1
        cell.userImg.layer.masksToBounds = true
        cell.userImg.layer.borderColor = UIColor.white.cgColor
        cell.userImg.layer.cornerRadius = (cell.userImg.frame.size.width) / 2
        cell.userImg.clipsToBounds = true
        
        cell.nameLabel?.text = displayedMembers
        cell.contentPreviewLabel?.text = content
        cell.dateLabel?.text = time
        
        return cell
    }
    
    // function adapted from: https://stackoverflow.com/questions/26207846/pass-data-through-segue
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected a cell")
        // Create a variable that you want to send based on the destination view controller
        // You can get a reference to the data by using indexPath shown below
        let selectedObj = data[indexPath.row] as! [String: Any]
        self.selectedChat = selectedObj["id"] as! String
    }
    
    // following function adapted from: https://stackoverflow.com/questions/44790227/pass-multiple-variables-through-segue-in-swift
    // passes id of the chat pressed to the chatViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chatPressed" {
            let cell = sender as? UITableViewCell
            
            let index: IndexPath? = tableView?.indexPath(for: cell!)
            let selectedObj = data[(index?.row)!] as! [String: Any]

            let id: String = selectedObj["id"] as! String
            let imageURL: String = selectedObj["imageURL"] as! String
            let recipientNames: [String] = selectedObj["recipients"] as! [String]
            let recipientIDs: [String] = selectedObj["recipientIDs"] as! [String]
            
            var displayedMembers: String = ""
            displayedMembers += recipientNames[0]
            
            for (index, recipient) in recipientNames.enumerated() {
                if (index != 0) {
                    displayedMembers = displayedMembers + ", " + recipient
                }
            }
            
            let chatViewController = segue.destination as! ChatViewController
            chatViewController.chatID = id
            chatViewController.imageURL = imageURL
            chatViewController.recipientName = displayedMembers
            chatViewController.recipientID = recipientIDs[0]
        }
    }
    

//    @IBOutlet var tableView: UITableView!
    var userId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userEmail: String = ""
    private var data: [Any] = [Any]()  // list of chat objects with chat ID, other user's name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FullChatViewController.handleMessageNotification(_:)), name: NSNotification.Name(rawValue: "messageNotification"), object: nil)
        
      //  view.bringSubview(toFront: toolbar)
        
        // https://stackoverflow.com/questions/29065219/swift-uitableview-didselectrowatindexpath-not-getting-called
        self.tableView.delegate = self
        self.tableView.dataSource = self

        self.tableView.estimatedRowHeight = 150.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;

        self.fetchChats(completion: { chats in
            self.data = chats
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
    }
    
    func fetchChats(completion: @escaping ([Any])->()) {
        
        let url = appDelegate.rootUrl + "api/chats"
        let userToken: String = UserDefaults.standard.string(forKey: "token")!
        
        let headers : [String:String] = [
            "Authorization": userToken,
            "Content-Type": "application/json"
        ]
        
        let _request = Alamofire.request(url, method: .get, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success:
                    completion(response.result.value as! [Any])
                case .failure(let error):
                    let alert = UIAlertController(title: "Error Fetching Chats", message: "Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    print(error)
                }
        }
    }
    

    // https://www.twilio.com/blog/2016/09/getting-started-with-socket-io-in-swift-on-ios.html
    @objc func handleMessageNotification(_ notification: Notification) {
        print("-----HANDLING MESSAGE-----")
        
        self.fetchChats(completion: { chats in
            self.data = chats
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
    }
    
}
