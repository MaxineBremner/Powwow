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
        print(message.isUser(user))
        if message.isUser(user){
            messageLabel.textColor = UIColor(red: (30/255.0), green: (189/255.0), blue: (200/255.0), alpha: 1.0)
            messageLabel.textAlignment = .Right
            distanceLabel.textAlignment = .Right
            messageLabel.numberOfLines = 0;
                  } else {
            messageLabel.textAlignment = .Left
            messageLabel.textColor = UIColor(red: (14/255.0), green: (151/255.0), blue: (160/255.0), alpha: 1.0)
        }
        
//This is to make a break once the number of characters exceeds a certain number in the messageLabel
        func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return true }
            
            let newLength = text.utf16.count + string.utf16.count - range.length
            return newLength <= 7
        }
        
        func textField(textField: UITextField, should
        
        
        distanceLabel.font = distanceLabel.font.fontWithSize(9)
        
        if let currentLocation = currentLocation, messageLocation = message.location {
            distanceLabel.text = "\((currentLocation.distanceFromLocation(messageLocation) / 1000).roundToPlaces(1))k"
        } else {
            distanceLabel.text = "Location unknown"
        }
        
        animateIn()
    }
    
    func animateIn() {
        UIView.animateWithDuration(1) { () -> Void in
            self.messageLabel.alpha = 5
        }
        
        
        
        
        
    }
    
}   