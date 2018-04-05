import UIKit
import QuartzCore

//source: https://www.raywenderlich.com/76433/how-to-make-a-custom-control-swift
class RangeSlider: UIControl {
    
    var slide_id = 0

    let trackLayer = RangeSliderTrackLayer()
    let lowerThumbLayer = RangeSliderThumbLayer()
    let upperThumbLayer = RangeSliderThumbLayer()
    var previousLocation = CGPoint()
    
    var minimumValue: Double = 18 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var maximumValue: Double = 99 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var lowerValue: Double = 18 {
        didSet {
            updateLayerFrames()
        }
    }
    
    var upperValue: Double = 99 {
        didSet {
            updateLayerFrames()
            
        }
        
    }
    
    var trackTintColor: UIColor = UIColor(white: 0.9, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var trackHighlightTintColor: UIColor = UIColor(red: 1.0, green: 0.65, blue: 0.35, alpha: 1.0) {
        didSet {
            trackLayer.setNeedsDisplay()
        }
    }
    
    var thumbTintColor: UIColor = UIColor(red: 1.0, green: 0.65, blue: 0.35, alpha: 1.0){
        didSet {
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var curvaceousness: CGFloat = 1.0 {
        didSet {
            trackLayer.setNeedsDisplay()
            lowerThumbLayer.setNeedsDisplay()
            upperThumbLayer.setNeedsDisplay()
        }
    }
    
    var thumbWidth: CGFloat {
        return CGFloat(bounds.height)
    }
    
    override var frame: CGRect {
        didSet {
            updateLayerFrames()
        }
    }
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        
        trackLayer.rangeSlider = self
        trackLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(trackLayer)
        
        lowerThumbLayer.rangeSlider = self
        lowerThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(lowerThumbLayer)
        
        upperThumbLayer.rangeSlider = self
        upperThumbLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(upperThumbLayer)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func updateLayerFrames() {
        
       // print("updating layer frames")
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        
        trackLayer.frame = bounds.insetBy(dx: 0.0, dy: bounds.height / 3)
        trackLayer.setNeedsDisplay()
        
        let lowerThumbCenter = CGFloat(positionForValue(value: lowerValue))
        
        lowerThumbLayer.frame = CGRect(x: lowerThumbCenter - thumbWidth / 2.0, y: 0.0, width: thumbWidth, height: thumbWidth)
        lowerThumbLayer.setNeedsDisplay()
        
        let upperThumbCenter = CGFloat(positionForValue(value: upperValue))
        upperThumbLayer.frame = CGRect(x: upperThumbCenter - thumbWidth / 2.0, y: 0.0,
                                       width: thumbWidth, height: thumbWidth)
        upperThumbLayer.setNeedsDisplay()
       
        self.sendActions(for: .valueChanged)
        

        CATransaction.commit()
    }
    
    
    func configRangeSlider(id: Int){
        slide_id = id
        if (id == 1){
            
            print("age")
            minimumValue = 18
            
            upperValue  = 99

            lowerValue = 18

            
            maximumValue = 99
  
        }
        if (id == 2){
            print("pace")
            minimumValue = 0
            
            upperValue  = 15
            
            lowerValue = 0
            
            maximumValue = 15
            
        }
        
        
        if (id == 3){
            print("prox")
            minimumValue = 0
            
            upperValue  = 25
            
            lowerValue = 0
            
            maximumValue = 25
        }
    }
    
  
    func positionForValue(value: Double) -> Double {
        _ = Double(thumbWidth)
        return Double(bounds.width - thumbWidth) * (value - minimumValue) /
            (maximumValue - minimumValue) + Double(thumbWidth / 2.0)
    }
    
    // Touch handlers
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        // Hit test the thumb layers
        if slide_id != 3 && lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.highlighted = true
            
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.highlighted = true
        }
        
        return lowerThumbLayer.highlighted || upperThumbLayer.highlighted
    }
    
    func boundValue(value: Double, toLowerValue lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // 1. Determine by how much the user has dragged
        let deltaLocation = Double(location.x - previousLocation.x)
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / Double(bounds.width - bounds.height)
        
        previousLocation = location
        
        // 2. Update the values
        if lowerThumbLayer.highlighted {
            lowerValue += deltaValue
            lowerValue = boundValue(value: lowerValue, toLowerValue: minimumValue, upperValue: upperValue)
        } else if upperThumbLayer.highlighted {
            upperValue += deltaValue
            upperValue = boundValue(value: upperValue, toLowerValue: lowerValue, upperValue: maximumValue)
        }
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.highlighted = false
        upperThumbLayer.highlighted = false
    }
}
