//
//  MessageCell.swift
//  Powwow
//
//  Created by apple on 19/04/2016.
//  Copyright © 2016 Kyle Goslan. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell  {
    
    var user = NSUserDefaults.standardUserDefaults().valueForKey("User") as! String
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: Message!
    
    func updateView() {
        messageLabel.text = message.message
        messageLabel.alpha = 1
        if message.isUser(user){
            backgroundColor = .redColor()
        }
        
        
        animateIn()
    }
    
    func animateIn() {
        UIView.animateWithDuration(1) { () -> Void in
            self.messageLabel.alpha = 1
        
        //MessageCell.animationDidStop(anim: CAAnimation, finished: true)
            
        }
        
    }
    
}