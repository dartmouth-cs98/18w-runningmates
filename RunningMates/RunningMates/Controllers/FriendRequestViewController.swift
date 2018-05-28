//
//  FriendRequestViewController.swift
//  RunningMates
//
//  Created by Jonathan Gonzalez on 5/27/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import Alamofire




protocol CellDelegate {
    func didTap(_ cell: FriendRequestPreviewCell, type: String)
}


class FriendRequestPreviewCell: UITableViewCell {
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    var delegate: CellDelegate?
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        self.delegate?.didTap(self, type: "accept")
    }
    @IBAction func denyButtonPressed(_ sender: UIButton) {
        self.delegate?.didTap(self, type: "deny")
    }
    
}


class FriendRequestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CellDelegate {
    
    var selectedChat: String = ""
    var userID: String = ""
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func didTap(_ cell: FriendRequestPreviewCell, type: String) {
        let indexPath = self.tableView.indexPath(for: cell)
        let userRequesting = data[(indexPath?.row)!] as! [String:Any]
        let targetId = userRequesting["_id"] as! String
        let firstName = userRequesting["firstName"] as! String
        var friendRequests = UserDefaults.standard.value(forKey: "requestsReceived") as! [String: Any]
        if (type == "accept") {
            UserManager.instance.sendMatchRequest(userId: self.userId, targetId: targetId, firstName: firstName, completion: { title, message in
                //https://www.simplifiedios.net/ios-show-alert-using-uialertcontroller/
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Close", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                self.data.remove(at: (indexPath?.row)!)
                friendRequests.removeValue(forKey: targetId)
                UserDefaults.standard.set(friendRequests, forKey: "requestsReceived")
                self.tableView.deleteRows(at: [indexPath!], with: .fade)
                

            })
        }
        else {
            self.data.remove(at: (indexPath?.row)!)
            friendRequests.removeValue(forKey: targetId)
            UserDefaults.standard.set(friendRequests, forKey: "requestsReceived")
            self.tableView.deleteRows(at: [indexPath!], with: .fade)

        }
        // do something with the index path
    }
    
    // function written with help from http://www.thomashanning.com/uitableview-tutorial-for-beginners/
    // and https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/#dynamic_data_contents
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FriendRequestLabelCell", for: indexPath) as! FriendRequestPreviewCell
        let friendRequests = UserDefaults.standard.value(forKey: "requestsReceived") as? [String: Any]
        if data.count > 0 && friendRequests!.count > 0{
            cell.delegate = self
            let userRequesting = data[indexPath.row] as! [String:Any]
            let images: [String] = userRequesting["images"] as! [String]
            let firstName: String = userRequesting["firstName"] as! String
            let lastName = userRequesting["lastName"] as! String
            let targetId = userRequesting["_id"] as! String

        
            var displayedName: String = ""
            displayedName += firstName + " " + lastName
        
        
            let url = URL(string: images[0])
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
        

            let unixTime = (friendRequests![targetId] as! TimeInterval) / 1000

            let date = Date(timeIntervalSince1970: unixTime)
            var localTimeZoneAbbreviation: String { return TimeZone.current.abbreviation() ?? "" }

            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: localTimeZoneAbbreviation) //Set timezone that you want

            dateFormatter.timeStyle = DateFormatter.Style.none //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
            let localDate = dateFormatter.string(from: date)

            cell.nameLabel?.text = displayedName
            cell.dateLabel?.text = localDate
        }
        return cell

    }
    
//    // function adapted from: https://stackoverflow.com/questions/26207846/pass-data-through-segue
//    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("selected a cell")
//        // Create a variable that you want to send based on the destination view controller
//        // You can get a reference to the data by using indexPath shown below
//        let selectedObj = data[indexPath.row] as! [String: Any]
//        self.selectedChat = selectedObj["id"] as! String
//    }
    
    // following function adapted from: https://stackoverflow.com/questions/44790227/pass-multiple-variables-through-segue-in-swift
    // passes id of the chat pressed to the chatViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "chatPressed" {
//            let cell = sender as? UITableViewCell
//            
//            let index: IndexPath? = tableView?.indexPath(for: cell!)
//            let selectedObj = data[(index?.row)!] as! [String: Any]
//            
//            let id: String = selectedObj["id"] as! String
//            let imageURL: String = selectedObj["imageURL"] as! String
//            let recipientNames: [String] = selectedObj["recipients"] as! [String]
//            let recipientIDs: [String] = selectedObj["recipientIDs"] as! [String]
//            
//            var displayedMembers: String = ""
//            displayedMembers += recipientNames[0]
//            
//            for (index, recipient) in recipientNames.enumerated() {
//                if (index != 0) {
//                    displayedMembers = displayedMembers + ", " + recipient
//                }
//            }
//            
//            let chatViewController = segue.destination as! ChatViewController
//            chatViewController.chatID = id
//            chatViewController.imageURL = imageURL
//            chatViewController.recipientName = displayedMembers
//            chatViewController.recipientID = recipientIDs[0]
//        }
    }
    
    
    //    @IBOutlet var tableView: UITableView!
    var userId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userEmail: String = ""
    private var data: [Any] = [Any]()  // list of chat objects with chat ID, other user's name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        if let requestsReceived = UserDefaults.standard.value(forKey: "requestsReceived") as? [String: Any] {
//        NotificationCenter.default.addObserver(self, selector: #selector(FullChatViewController.handleMessageNotification(_:)), name: NSNotification.Name(rawValue: "messageNotification"), object: nil)
//
        //  view.bringSubview(toFront: toolbar)
        
        // https://stackoverflow.com/questions/29065219/swift-uitableview-didselectrowatindexpath-not-getting-called
        
            if requestsReceived.count > 0 {
                self.tableView.delegate = self
                self.tableView.dataSource = self
            
                self.tableView.estimatedRowHeight = 200.0;
                self.tableView.rowHeight = UITableViewAutomaticDimension;
            
                self.fetchFriendRequests(completion: { friendRequests in
                    self.data = friendRequests
                    self.tableView.dataSource = self
                    if self.data.count > 0 && requestsReceived.count > 0{
                        self.tableView.reloadData()

                    }
                })
            }
        }
    }
    
    func fetchFriendRequests(completion: @escaping ([Any])->()) {
        if let friendRequests = UserDefaults.standard.value(forKey: "requestsReceived") as? [String: Any] {
            let url = appDelegate.rootUrl + "api/friendRequests"
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
        
        
        
    }
    
    
    // https://www.twilio.com/blog/2016/09/getting-started-with-socket-io-in-swift-on-ios.html
    @objc func handleMessageNotification(_ notification: Notification) {
        print("-----HANDLING MESSAGE-----")
        
        self.fetchFriendRequests(completion: { friendRequests in
            self.data = friendRequests
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
    }
}
