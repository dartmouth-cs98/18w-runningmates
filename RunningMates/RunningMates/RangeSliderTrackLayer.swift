//
//  RangeSliderTrackLayer.swift
//  RunningMates
//
//  Created by Sara Topic on 03/03/2018.
//  Copyright © 2018 Apple Inc. All rights reserved.
//
//source: https://www.raywenderlich.com/76433/how-to-make-a-custom-control-swift

import UIKit
import QuartzCore

class RangeSliderTrackLayer: CALayer {
    weak var rangeSlider: RangeSlider?

    override func draw(in ctx: CGContext!) {
        print("im even here")

        if let slider = rangeSlider {
            // Clip
            let cornerRadius = bounds.height * slider.curvaceousness / 5.0
            let path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
            ctx.addPath(path.cgPath)
            
            // Fill the track
            ctx.setFillColor(slider.trackTintColor.cgColor)
            ctx.addPath(path.cgPath)
            (ctx).fillPath()
            
            // Fill the highlighted range
            ctx.setFillColor(slider.trackHighlightTintColor.cgColor)
            print("fillding highlighted range")
            let lowerValuePosition = CGFloat(slider.positionForValue(value: slider.lowerValue))
            let upperValuePosition = CGFloat(slider.positionForValue(value: slider.upperValue))
            let rect = CGRect(x: lowerValuePosition, y: 0.0, width: upperValuePosition - lowerValuePosition, height: bounds.height)
            ctx.fill(rect)
        }
    }


}

