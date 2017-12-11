//
//  ReplacementRangeSlider.swift
//  ReplacementRangeSlider
//
//  Created by kaneko on 2017/11/17.
//  Copyright © 2017年 kaneko. All rights reserved.
//

import Foundation
import UIKit

public protocol ReplacementRangeSliderDelegate: class {
    
    /**
     delegate
     */
    func replacementRangeSliderValueChanged(min: CGFloat, max: CGFloat)
}

public class ReplacementRangeSlider: UIView {
    
    @IBInspectable public var minimumValue: CGFloat = 0.0
    
    @IBInspectable public var maximumValue: CGFloat = 0.0
    
    @IBInspectable public var maxValue: CGFloat = 0.0
    
    @IBInspectable public var minValue: CGFloat = 0.0
    
    @IBInspectable public var moveValue: CGFloat = 0.0
    
    @IBInspectable public var circleSize: CGFloat = 0.0
    
    @IBInspectable public var slideBackgroundColor : UIColor = UIColor.black
    
    @IBInspectable public var barHeight: CGFloat = 0.0
    
    @IBInspectable public var leftThumbColor : UIColor = UIColor.black
    
    @IBInspectable public var rightThumbColor : UIColor = UIColor.black
    
    public var delegate: ReplacementRangeSliderDelegate?
    
    var leftThumb: UIView = UIView()
    
    var rightThumb: UIView = UIView()
    
    var sliderView: UIView = UIView()
    
    var bar = UIView()
    
    var coordinates: [String: CGFloat] = [:]
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func setUp() {
        
        let min = (minValue - minimumValue) / maximumValue
        let max = maxValue / maximumValue
        
        bar.backgroundColor = slideBackgroundColor
        sliderView.backgroundColor = UIColor.gray
        
        let defaultSlideViewX = self.frame.size.width * CGFloat(min)
        let defaultSlideViewWidth = CGFloat(self.frame.size.width * CGFloat(max))
        
        sliderView.frame = CGRect(x: 0,
                                  y: self.frame.height / 2,
                                  width: self.frame.width,
                                  height: barHeight)
        
        bar.frame = CGRect(x: defaultSlideViewX,
                           y: self.frame.height / 2,
                           width: defaultSlideViewWidth - defaultSlideViewX ,
                           height: barHeight)
        
        leftThumb = UIView(frame: CGRect(x: bar.frame.origin.x, y: bar.frame.origin.y - (circleSize / 2), width: circleSize, height: circleSize))
        leftThumb.layer.cornerRadius = leftThumb.frame.width / 2
        leftThumb.backgroundColor = leftThumbColor
        let leftGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragLeftThumb(gestureRecognizer:)))
        leftThumb.addGestureRecognizer(leftGesture)
        
        rightThumb = UIView(frame: CGRect(x: bar.frame.size.width + bar.frame.origin.x - circleSize, y: bar.frame.origin.y - (circleSize / 2), width: circleSize, height: circleSize))
        rightThumb.layer.cornerRadius = rightThumb.frame.width/2
        rightThumb.backgroundColor = rightThumbColor
        let rightGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragRightThumb(gestureRecognizer:)))
        rightThumb.addGestureRecognizer(rightGesture)
        
        coordinates = ["left": leftThumb.center.x, "right": rightThumb.frame.origin.x]
        
        self.addSubview(sliderView)
        self.addSubview(bar)
        self.addSubview(leftThumb)
        self.addSubview(rightThumb)
    }
    
    // MARK: - UIPanGestureRecognizer
    @objc func didDragLeftThumb(gestureRecognizer: UIPanGestureRecognizer) {
        let point: CGPoint = gestureRecognizer.translation(in: sliderView)
        if checkThumbMoveRange(gesture: gestureRecognizer) {
            return
        }
        
        coordinates["left"] = leftThumb.frame.origin.x
        
        if changeThumb(gesture: gestureRecognizer) {
            valueChangeRight(point: gestureRecognizer, translationPoint: point)
        } else {
            valueChangeLeft(point: gestureRecognizer, translationPoint: point)
        }
        delegate?.ReplacementRangeSliderValueChanged(min: minValue, max: maxValue)
    }
    
    @objc func didDragRightThumb(gestureRecognizer: UIPanGestureRecognizer) {
        let point: CGPoint = gestureRecognizer.translation(in: sliderView)
        if checkThumbMoveRange(gesture: gestureRecognizer) {
            return
        }
        
        coordinates["right"] = rightThumb.frame.origin.x
        
        if changeThumb(gesture: gestureRecognizer) {
            valueChangeLeft(point: gestureRecognizer, translationPoint: point)
        } else {
            valueChangeRight(point: gestureRecognizer, translationPoint: point)
        }
        delegate?.ReplacementRangeSliderValueChanged(min: minValue, max: maxValue)
    }
    
    private func valueChangeLeft(point: UIPanGestureRecognizer, translationPoint: CGPoint) {
        
        bar.frame.origin.x = rightThumb.frame.origin.x
        bar.frame.size.width = leftThumb.frame.origin.x - rightThumb.frame.origin.x
        
        if translationPoint.x > 0.0 {
            minValue = moveValue * CGFloat(checkMemory(point: point))
            minValue += minimumValue - moveValue
        } else {
            minValue = moveValue * CGFloat(checkMemory(point: point))
            minValue += minimumValue - moveValue
        }
    }
    
    private func valueChangeRight(point: UIPanGestureRecognizer, translationPoint: CGPoint) {
        
        bar.frame.origin.x = leftThumb.frame.origin.x
        bar.frame.size.width = rightThumb.frame.origin.x - leftThumb.frame.origin.x
        
        if translationPoint.x > 0.0 {
            maxValue = moveValue * CGFloat(checkMemory(point: point))
            maxValue += minimumValue - moveValue
        } else {
            maxValue = moveValue * CGFloat(checkMemory(point: point))
            maxValue += minimumValue - moveValue
        }
    }
    
    private func checkMemory(point: UIPanGestureRecognizer) -> Int {
        let counta = Int((maximumValue - minimumValue) / moveValue)
        let memory = (self.frame.width - circleSize) / CGFloat(counta)
        
        var memoryInt = Int()
        for i in 1...counta + 1 {
            memoryInt = i
            if point.view!.frame.origin.x < memory * CGFloat(memoryInt) {
                break
            }
        }
        return memoryInt
    }
    
    private func checkThumbMoveRange(gesture: UIPanGestureRecognizer) -> Bool{
        let point: CGPoint = gesture.translation(in: sliderView)
        if point.x == 0.0 {
            return true
        }
        if point.x + gesture.view!.frame.origin.x < sliderView.frame.origin.x {
            gesture.view!.frame.origin.x = 0
            gesture.setTranslation(CGPoint.zero, in: sliderView)
            return false
        }
        if point.x + gesture.view!.frame.origin.x + circleSize > sliderView.frame.size.width {
            gesture.view!.frame.origin.x = sliderView.frame.size.width - circleSize
            gesture.setTranslation(CGPoint.zero, in: sliderView)
            return false
        }
        
        gesture.view!.center.x += point.x
        gesture.setTranslation(CGPoint.zero, in: sliderView)
        return false
    }
    
    private func changeThumb(gesture: UIPanGestureRecognizer) -> Bool{
        let sortCordinates = coordinates.sorted(by: { $0.value < $1.value })
        
        if sortCordinates.first?.key == "right" {
            return true
        }
        return false
    }
}

