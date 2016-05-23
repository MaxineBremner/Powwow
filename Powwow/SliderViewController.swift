
//
//  LocationSlider.swift
//  Powwow
//
//  Created by apple on 17/05/2016.
//  Copyright © 2016 Kyle Goslan. All rights reserved.
//

import UIKit

class SliderViewController: UIViewController {
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBAction func sliderChanged(sender: AnyObject) {
        let slider = sender as! UISlider
        distanceLabel.text = "\(Int(slider.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let savedValue = NSUserDefaults.standardUserDefaults().valueForKey("Distance") as? Int {
            distanceSlider.value = Float(savedValue)
        } else {
            distanceSlider.value = 1000
        }
        distanceLabel.text = "\(Int(distanceSlider.value))"
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(Int(distanceSlider.value), forKey: "Distance")
    }
    
    
}