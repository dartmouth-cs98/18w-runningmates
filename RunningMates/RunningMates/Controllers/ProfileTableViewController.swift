//
//  ProfileTableViewController.swift
//  RunningMates
//
//  Created by Divya Kalidindi on 4/26/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit
import ExpyTableView

//https://github.com/okhanokbay/ExpyTableView
class ProfileTableViewController: UIViewController {
    
    let sampleData = [
        ["Choose up to 4 photos", "Photo1", "Photo2", "Photo3", "Photo4"],
        ["Enter your basic information", "First", "Last", "Gender", "DOB"],
        ["Tell us about yourself", "text box here"],
        ["Enter your running data", "Miles/week", "Runs/week", "Races Done"]
    ]
    
    
    @IBOutlet weak var expandableTableView: ExpyTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        expandableTableView.dataSource = self
        expandableTableView.delegate = self
        
        expandableTableView.rowHeight = UITableViewAutomaticDimension
        expandableTableView.estimatedRowHeight = 44
        
        //Alter the animations as you want
        expandableTableView.expandingAnimation = .fade
        expandableTableView.collapsingAnimation = .fade
        
        expandableTableView.tableFooterView = UIView()
        
        navigationItem.title = "Edit Profile"
        
        //If your app only works in portrait mode, you don't have to add this. https://github.com/okhanokbay/ExpyTableView/issues/3
        NotificationCenter.default.addObserver(self, selector: #selector(orientationDidChange), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    @objc private func orientationDidChange() {
        switch UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown, .landscapeLeft, .landscapeRight:
            expandableTableView.reloadSections(IndexSet(Array(expandableTableView.expandedSections.keys)), with: .none)
        default:break
        }
    }
}

//MARK: ExpyTableViewDataSourceMethods
extension ProfileTableViewController: ExpyTableViewDataSource {
    
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }
    
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhoneNameTableViewCell.self)) as! PhoneNameTableViewCell
        cell.labelPhoneName.text = sampleData[section].first!
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        return cell
    }
}

//MARK: ExpyTableView delegate methods
extension ProfileTableViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {
        
        switch state {
        case .willExpand:
            print("WILL EXPAND")
            
        case .willCollapse:
            print("WILL COLLAPSE")
            
        case .didExpand:
            print("DID EXPAND")
            
        case .didCollapse:
            print("DID COLLAPSE")
        }
    }
}

extension ProfileTableViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Choose Photos"
        }
        if (section == 1) {
                return "Basic Info"
        }
        if (section == 2) {
            return "About me"
        }
        else {
            return "Running Stats"
        }
    }
}

extension ProfileTableViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If you don't deselect the row here, seperator of the above cell of the selected cell disappears.
        //Check here for detail: https://stackoverflow.com/questions/18924589/uitableviewcell-separator-disappearing-in-ios7
        
        tableView.deselectRow(at: indexPath, animated: false)
        
        //This solution obviously has side effects, you can implement your own solution from the given link.
        //This is not a bug of ExpyTableView hence, I think, you should solve it with the proper way for your implementation.
        //If you have a generic solution for this, please submit a pull request or open an issue.
        
        print("DID SELECT row: \(indexPath.row), section: \(indexPath.section)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

//MARK: UITableView Data Source Methods
extension ProfileTableViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Please see https://github.com/okhanokbay/ExpyTableView/issues/12
        // The cell instance that you return from expandableCellForSection: data source method is actually the first row of belonged section. Thus, when you return 4 from numberOfRowsInSection data source method, first row refers to expandable cell and the other 3 rows refer to other rows in this section.
        // So, always return the total row count you want to see in that section

        print("Row count for section \(section) is \(sampleData[section].count)")
        return sampleData[section].count + 1 // +1 here is for BuyTableViewCell
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

//        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BuyTableViewCell.self)) as! BuyTableViewCell
//            cell.layoutMargins = UIEdgeInsets.zero
//            cell.showSeparator()
//            return cell
//
//        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SpecificationTableViewCell.self)) as! SpecificationTableViewCell
            cell.labelSpecification.text = (sampleData[indexPath.section])[indexPath.row]
            cell.layoutMargins = UIEdgeInsets.zero
            cell.hideSeparator()
            return cell
        
    }
}
