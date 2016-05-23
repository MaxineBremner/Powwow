//
//  Show.swift
//  Powwow
//
//  Created by Kyle Goslan on 13/11/2015.
//  Copyright © 2015 Kyle Goslan. All rights reserved.
//

import Foundation
import SwiftyJSON

class Show {

    let id: Int!
    let title: String!
    let image: UIImage!
    
    init(data: JSON) {
    
        title = data["Title"].stringValue
        id = data ["Id"].intValue
        image = UIImage(named: title)
    
    }
 
    

}