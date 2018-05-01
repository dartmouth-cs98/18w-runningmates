//
//  EmergencyContactFullViewController.swift
//  RunningMates
//
//  Created by Sara Topic on 26/04/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

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
//based on this tutorial https://developer.apple.com/library/content/referencelibrary/GettingStarted/DevelopiOSAppsSwift/ImplementNavigation.html#//apple_ref/doc/uid/TP40015214-CH16-SW1
import UIKit
import Foundation
import Alamofire
import os.log
import MessageUI

class EmergencyContactCell: UITableViewCell {
    @IBOutlet weak var contactName: UILabel!
}


class EmergencyContactFullViewController:UITableViewController
{
    //MARK: Properties
    
    var contacts = [EmergencyContact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem
        
        if let savedContacts = loadContacts() {
            contacts += savedContacts
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ECCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EmergencyContactCell  else {
            fatalError("The dequeued cell is not an instance of ECCell.")
        }
        
        // Fetches the appropriate contact for the data source layout.
        let contact = contacts[indexPath.row]
        cell.contactName.text = contact.FirstName;
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            contacts.remove(at: indexPath.row)
            saveContact()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    //MARK: - Navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new contact.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let EmergencyContactViewController = segue.destination as? EmergencyContactViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCell = sender as? EmergencyContactCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedContact = contacts[indexPath.row]
            EmergencyContactViewController.contact = selectedContact
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    
    //MARK: Actions
    
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? EmergencyContactViewController, let contact = sourceViewController.contact {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                contacts[selectedIndexPath.row] = contact
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: contacts.count, section: 0)
                
                contacts.append(contact)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            saveContact()
        }
    }
    
    private func saveContact() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(contacts, toFile: EmergencyContact.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("cpmtact successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save contact...", log: OSLog.default, type: .error)
        }
        
 
    }
    private func loadContacts() -> [EmergencyContact]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: EmergencyContact.ArchiveURL.path) as? [EmergencyContact]
    }

}
