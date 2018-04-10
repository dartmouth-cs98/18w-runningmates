//
//  FullChatViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 07/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
// http://www.thomashanning.com/uitableview-tutorial-for-beginners/
// https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/#dynamic_data_contents

import UIKit
import Foundation
import Alamofire


class FullChatViewController: UITableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    // function written with help from http://www.thomashanning.com/uitableview-tutorial-for-beginners/
    // and https://www.ralfebert.de/ios-examples/uikit/uitableviewcontroller/#dynamic_data_contents
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let text = data[indexPath.row] as! [String:Any] //2.
        
        cell.textLabel?.text = text["id"] as! String //3.
        print("id: " + String(describing: text["id"]))
        
        return cell //4.
    }
    

//    @IBOutlet var tableView: UITableView!
    var userId: String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userEmail: String = ""
    private var data: [Any] = [Any]()  // list of chat objects with chat ID, other user's name
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userEmail = appDelegate.userEmail;
        
        fetchChats(completion: { chats in
            self.data = chats
            print("chats:\n")
            print(chats)
            self.tableView.dataSource = self
            self.tableView.reloadData()
        })
        
    }
    
    func fetchChats(completion: @escaping ([Any])->()) {
        
        let url = appDelegate.rootUrl + "api/chats"
        
        let params: Parameters = [
            "user": userEmail
        ]
        
        let _request = Alamofire.request(url, method: .get, parameters: params)
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
        debugPrint("whole _request ****",_request)
    }
    
}
