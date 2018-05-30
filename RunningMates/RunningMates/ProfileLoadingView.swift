//
//  ProfileLoadingView.swift
//  RunningMates
//
//  Created by dali on 5/30/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class ProfileLoadingView: UIView {
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
