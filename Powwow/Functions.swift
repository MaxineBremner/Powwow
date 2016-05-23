//
//  Functions.swift
//  Powwow
//
//  Created by apple on 19/04/2016.
//  Copyright © 2016 Kyle Goslan. All rights reserved.
//

import Foundation

func randomString(length: Int) -> String {
    let charactersString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let charactersArray : [Character] = Array(charactersString.characters)
    
    var string = "x"
    for _ in 0..<length {
        string.append(charactersArray[Int(arc4random()) % charactersArray.count])
    }
    
    return string
}


extension Double {
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}