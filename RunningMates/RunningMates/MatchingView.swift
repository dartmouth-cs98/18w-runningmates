//
//  MatchingView.swift
//  RunningMates
//
//  Created by Sudikoff Lab iMac on 2/12/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import Foundation
import UIKit

class MatchingView: UIView {
    @IBOutlet var matchingView: UIView!
//    @IBOutlet weak var peopleButton: UIButton!
//    @IBOutlet weak var eventsButton: UIButton!
//    @IBOutlet weak var profilePic: UIImageView!
//    @IBOutlet weak var avgRunsLabel: UILabel!
//    @IBOutlet weak var achievementsLabel: UILabel!
//    @IBOutlet weak var bioLabel: UILabel!
//    @IBOutlet weak var matchButton: UIButton!
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var hometownLabel: UILabel!

    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        commonInit()
    }

    
    private func commonInit() {
        Bundle.main.loadNibNamed("Matching", owner: self, options: nil)
//        addSubview(matchingView)
//        matchingView.frame = self.bounds
        matchingView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    }
}
