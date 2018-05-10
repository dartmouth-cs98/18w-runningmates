//
//  MatchingCardOverlay.swift
//  RunningMates
//
//  Created by dali on 5/10/18.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
// used this code for reference here: https://github.com/Yalantis/Koloda/blob/master/Example/Koloda/CustomOverlayView.swift

import UIKit
import Koloda

private let overlayRightImage = "match_image"
private let overlayLeftImage = "skip_image"

class MatchingCardOverlay: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection?  {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImage)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImage)
            default:
                overlayImageView.image = nil
            }
        }
    }
}
