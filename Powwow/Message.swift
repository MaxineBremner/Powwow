//
//  Message.swift
//  Powwow
//
//  Created by Kyle Goslan on 12/04/2016.
//  Copyright © 2016 Kyle Goslan. All rights reserved.
//

//new comment

import Foundation
import SwiftyJSON
import CoreLocation

class Message {
    
    let id: Int!
    let message: String!
    let showId: Int!
    let user: String!
    var location: CLLocation?
    let sentTime: NSDate!
    
    init(data: JSON) {
        
        message = data["Message"].stringValue
        id = data["Id"].intValue
        showId = data["ProgramId"].intValue
        user = data["User"].stringValue
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        sentTime = dateFormatter.dateFromString(data["SentTime"].stringValue)!
        
        if data["Lat"].doubleValue != 0.0 {
            location = CLLocation(latitude: data["Lat"].doubleValue, longitude: data["Lng"].doubleValue)
        }
    }
    
    func isUser(user: String) -> Bool {
        return user == self.user
    }
    
}




