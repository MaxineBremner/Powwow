//
//  MessageCell.swift
//  Powwow
//
//  Created by apple on 19/04/2016.
//  Copyright © 2016 Kyle Goslan. All rights reserved.
//

import UIKit
import CoreLocation

class MessageCell: UITableViewCell  {
    
    var user = NSUserDefaults.standardUserDefaults().valueForKey("User") as! String
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: Message!
    
    func updateView(currentLocation: CLLocation?) {
        messageLabel.text = message.message
        messageLabel.alpha = 1
        if message.isUser(user){
            backgroundColor = .purpleColor()
            messageLabel.textAlignment = .Right
        } else {
            messageLabel.textAlignment = .Left
        }
        
        if let currentLocation = currentLocation, messageLocation = message.location {
            distanceLabel.text = "\((currentLocation.distanceFromLocation(messageLocation) / 1000)) kilometers away"
        } else {
            distanceLabel.text = "Location unknowen"
        }
        
        animateIn()
    }
    
    func animateIn() {
        UIView.animateWithDuration(1) { () -> Void in
            self.messageLabel.alpha = 3
        
                
        }
        
    }
    
}