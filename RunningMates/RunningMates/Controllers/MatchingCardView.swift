//
//  MatchingCardView.swift
//  RunningMates
//
//  Created by dali on 4/30/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class MatchingCardView: UIView {
    
    @IBOutlet weak var profileImage: UIImageView!
   // @IBOutlet weak var userInfoText: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var locationText: UILabel!
    @IBOutlet weak var bioText: UILabel!
    @IBOutlet weak var totalMilesText: UILabel!
    @IBOutlet weak var averageRunLengthText: UILabel!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// This helped me here: https://medium.com/theappspace/swift-custom-uiview-with-xib-file-211bb8bbd6eb
extension UIView {
    
    @discardableResult
    func fromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
       
        return contentView
    }
}
