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
           backgroundColor = UIColor(red: (30/255.0), green: (189/255.0), blue: (200/255.0), alpha: 1.0)
        
        }
        
        
        animateIn()
    }
    
    func animateIn() {
        UIView.animateWithDuration(1) { () -> Void in
            self.messageLabel.alpha = 3
        
                
        }
        
    }
    
}