//
//  RangeSlider.swift
//  RangeSlider
//
//  Created by kaneko on 2017/11/17.
//  Copyright © 2017年 kaneko. All rights reserved.
//

import Foundation
import UIKit

protocol RangeSliderDelegate: class {
    /**
     選択された値を通知する
     */
    func RangeSliderValueChanged(min: CGFloat, max: CGFloat)
}

class RangeSlider: UIView {
    // スライダーの最大値
    @IBInspectable var minimumValue: CGFloat = 0.0
    // スライダーの最小値
    @IBInspectable var maximumValue: CGFloat = 0.0
    // デフォルトの最大値
    @IBInspectable var maxValue: CGFloat = 0.0
    // デフォルトの最小値
    @IBInspectable var minValue: CGFloat = 0.0
    // 動かす値
    @IBInspectable var moveValue: CGFloat = 0.0
    // 円のサイズ
    @IBInspectable var circleSize: CGFloat = 0.0
    // バーの間の背景色
    @IBInspectable var slideBackgroundColor : UIColor = UIColor.black
    // バーの高さ
    @IBInspectable var barHeight: CGFloat = 0.0
    // 左のつまみの色
    @IBInspectable var leftThumbColor : UIColor = UIColor.black
    // 右のつまみの色
    @IBInspectable var rightThumbColor : UIColor = UIColor.black
    // 通知クラス
    weak var delegate: RangeSliderDelegate?
    // 左のつまみ
    var leftThumb: UIView = UIView()
    // 右のつまみ
    var rightThumb: UIView = UIView()
    // 最小値から最大地までの線
    var sliderView: UIView = UIView()
    // 設定している間のバー
    var bar = UIView()
    // ２つのつまみの座標を保持する
    var coordinates: [String: CGFloat] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUp() {
        // デフォルト値float値を設定して初期位置を設定する
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
        
        // 左のつまみ
        leftThumb = UIView(frame: CGRect(x: bar.frame.origin.x, y: bar.frame.origin.y - (circleSize / 2), width: circleSize, height: circleSize))
        leftThumb.layer.cornerRadius = leftThumb.frame.width / 2
        leftThumb.backgroundColor = leftThumbColor
        let leftGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragLeftThumb(gestureRecognizer:)))
        leftThumb.addGestureRecognizer(leftGesture)
        
        // 右のつまみ
        rightThumb = UIView(frame: CGRect(x: bar.frame.size.width + bar.frame.origin.x - circleSize, y: bar.frame.origin.y - (circleSize / 2), width: circleSize, height: circleSize))
        rightThumb.layer.cornerRadius = rightThumb.frame.width/2
        rightThumb.backgroundColor = rightThumbColor
        let rightGesture = UIPanGestureRecognizer(target: self, action: #selector(didDragRightThumb(gestureRecognizer:)))
        rightThumb.addGestureRecognizer(rightGesture)
        
        // 座標を肘する
        coordinates = ["left": leftThumb.center.x, "right": rightThumb.frame.origin.x]
        
        // 画面追加
        self.addSubview(sliderView)
        self.addSubview(bar)
        self.addSubview(leftThumb)
        self.addSubview(rightThumb)
    }
    
    // MARK: - UIPanGestureRecognizer
    
    // 最小値
    @objc func didDragLeftThumb(gestureRecognizer: UIPanGestureRecognizer) {
        let point: CGPoint = gestureRecognizer.translation(in: sliderView)
        if checkThumbMoveRange(gesture: gestureRecognizer) {
            return
        }
        // 座標を変更
        coordinates["left"] = leftThumb.frame.origin.x
        
        if changeThumb(gesture: gestureRecognizer) {
            // 右のつまみを選択した時の処理を行う
            valueChangeRight(point: gestureRecognizer, translationPoint: point)
        } else {
            valueChangeLeft(point: gestureRecognizer, translationPoint: point)
        }
        delegate?.RangeSliderValueChanged(min: minValue, max: maxValue)
    }
    
    // 最大値
    @objc func didDragRightThumb(gestureRecognizer: UIPanGestureRecognizer) {
        let point: CGPoint = gestureRecognizer.translation(in: sliderView)
        if checkThumbMoveRange(gesture: gestureRecognizer) {
            return
        }
        // 座標を変更
        coordinates["right"] = rightThumb.frame.origin.x
        
        if changeThumb(gesture: gestureRecognizer) {
            // 左のつまみを選択した時の処理を行う
            valueChangeLeft(point: gestureRecognizer, translationPoint: point)
        } else {
            valueChangeRight(point: gestureRecognizer, translationPoint: point)
        }
        delegate?.RangeSliderValueChanged(min: minValue, max: maxValue)
    }
    
    private func valueChangeLeft(point: UIPanGestureRecognizer, translationPoint: CGPoint) {
        
        bar.frame.origin.x = rightThumb.frame.origin.x
        bar.frame.size.width = leftThumb.frame.origin.x - rightThumb.frame.origin.x

        // 移動していなければ処理終了
        if translationPoint.x > 0.0 {
            // みぎに動かした
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
        
        // 移動していなければ処理終了
        if translationPoint.x > 0.0 {
            // みぎに動かした
            maxValue = moveValue * CGFloat(checkMemory(point: point))
            maxValue += minimumValue - moveValue
        } else {
            // 左に動かした
            maxValue = moveValue * CGFloat(checkMemory(point: point))
            maxValue += minimumValue - moveValue
        }
    }
    
    private func checkMemory(point: UIPanGestureRecognizer) -> Int {
        // 移動値
        let counta = Int((maximumValue - minimumValue) / moveValue)
        // 移動値一つに対するメモリ
        let memory = (self.frame.width - circleSize) / CGFloat(counta)
        
        // 現在の座標を計算してcountaのどのメモリ位置にいるか判定して、メモリ番号を渡す
        var memoryInt = Int()
        for i in 1...counta + 1 {
            memoryInt = i
            // 移動した分がメモリより小さかったら
            if point.view!.frame.origin.x < memory * CGFloat(memoryInt) {
                break
            }
        }
        return memoryInt
    }
    
    private func checkThumbMoveRange(gesture: UIPanGestureRecognizer) -> Bool{
        let point: CGPoint = gesture.translation(in: sliderView)
        // 移動チェック
        if point.x == 0.0 {
            return true
        }
        // 左の表示範囲チェック
        if point.x + gesture.view!.frame.origin.x < sliderView.frame.origin.x {
            gesture.view!.frame.origin.x = 0
            gesture.setTranslation(CGPoint.zero, in: sliderView)
            return false
        }
        // 右の表示範囲チェック
        if point.x + gesture.view!.frame.origin.x + circleSize > sliderView.frame.size.width {
            gesture.view!.frame.origin.x = sliderView.frame.size.width - circleSize
            gesture.setTranslation(CGPoint.zero, in: sliderView)
            return false
        }
        
        //ドラッグした部品の座標に移動量を加算する
        gesture.view!.center.x += point.x
        gesture.setTranslation(CGPoint.zero, in: sliderView)
        return false
    }
    
    private func changeThumb(gesture: UIPanGestureRecognizer) -> Bool{
        let sortCordinates = coordinates.sorted(by: { $0.value < $1.value })
        // 右のつまみが左より少ない場合、または左のつまみが右より大きくなった場合、役割を変更する
        if sortCordinates.first?.key == "right" {
            print("入れ替え開始！")
            return true
        }
        return false
    }
}
