//
//  ViewController.swift
//  RangeSlider
//
//  Created by kaneko on 2017/11/17.
//  Copyright © 2017年 kaneko. All rights reserved.
//

import UIKit
import ReplacementRangeSlider

class ViewController: UIViewController , ReplacementRangeSliderDelegate{
    func ReplacementRangeSliderValueChanged(min: CGFloat, max: CGFloat) {
        minLabel.text = String(format: "%f", roundf(Float(min / 1000)) * 1000)
        maxLabel.text = String(format: "%f", roundf(Float(max / 1000)) * 1000)
    }
    
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var slider: ReplacementRangeSlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        minLabel.text = String(describing: slider.minValue)
        maxLabel.text = String(describing: slider.maxValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        slider.delegate = self
        slider.setUp()
    }

}

