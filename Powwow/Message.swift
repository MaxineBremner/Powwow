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

class Message {
    
    let id: Int!
    let message: String!
    let showId: Int!
    
    
    init(data: JSON) {
        
        message = data["Message"].stringValue
        id = data["Id"].intValue
        showId = data["ProgramId"].intValue
        
    }
    
}
