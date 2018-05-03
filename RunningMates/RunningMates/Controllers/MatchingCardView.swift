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
    @IBOutlet weak var userInfoText: UILabel!
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    func commonInit(userInfo: String, userImage: UIImage) {
        profileImage.image = userImage
        userInfoText.text = userInfo
    }
    
}

extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
       // contentView.layoutAttachAll(to: self)
        return contentView
    }
}
