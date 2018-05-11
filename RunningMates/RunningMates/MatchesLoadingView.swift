//
//  MatchesLoadingView.swift
//  RunningMates
//
//  Created by dali on 5/11/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//

import UIKit

class MatchesLoadingView: UIView {
    
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
    func fromNib2() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        print("nibname = " + nibName)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let contentView = nib.instantiate(withOwner: self, options: nil).first as! MatchingCardView
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }
}
