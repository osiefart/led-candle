//
//  Validate.swift
//  playbulb
//
//  Created by Olaf Siefart on 19.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//

import Foundation

class Validate {
    
    class func isInRange (_ value:Int, _ min:Int, _ max:Int) {
        let LOGGER = Logger("Validate")
        if !(min <= value && value <= max){
            LOGGER.error("Value \(value) not between \(min) und \(max)")
            exit(0)
        }
    }
    
}
