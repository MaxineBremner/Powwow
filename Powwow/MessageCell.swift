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
    @IBOutlet weak var messageLabel: UITextView!
    
    var message: Message!
    
    func updateView(currentLocation: CLLocation?) {
        
        
        messageLabel.layer.cornerRadius = 10
        
        self.selectionStyle = .None
        self.backgroundColor = .clearColor()
        
        messageLabel.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
        messageLabel.text = message.message
        messageLabel.alpha = 1
        if message.isUser(user){
            messageLabel.layer.backgroundColor = UIColor(red: (30/255.0), green: (189/255.0), blue: (200/255.0), alpha: 1.0).CGColor
            messageLabel.textColor = UIColor(red: (255/255), green: (255/255), blue:(255/255), alpha: 1.0)
            messageLabel.textAlignment = .Right
            distanceLabel.textAlignment = .Right
                  } else {
            messageLabel.layer.backgroundColor = UIColor(red: (255/255), green: (255/255), blue:(255/255), alpha: 1.0).CGColor
            messageLabel.textColor = UIColor(red: (30/255.0), green: (189/255.0), blue: (200/255.0), alpha: 1.0)
            messageLabel.textAlignment = .Left
            messageLabel.textColor = UIColor(red: (14/255.0), green: (151/255.0), blue: (160/255.0), alpha: 1.0)
        }

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
    
    func selectedState() {
        print("selected")
    }
    
}


extension String {
    func sizeForWidth(width: CGFloat, font: UIFont) -> CGSize {
        let attr = [NSFontAttributeName: font]
        let height = NSString(string: self).boundingRectWithSize(CGSize(width: width, height: CGFloat.max), options:.UsesLineFragmentOrigin, attributes: attr, context: nil).height
        return CGSize(width: width, height: ceil(height))
    }
}



extension UITextView{
    
    func numberOfLines() -> Int{
        if let fontUnwrapped = self.font{
            return Int(self.contentSize.height / fontUnwrapped.lineHeight)
        }
        return 0
    }
    
}