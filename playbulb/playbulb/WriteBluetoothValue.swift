//
//  WriteBluetoothValue.swift
//  playbulb
//
//  Created by Olaf Siefart on 19.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//

import Foundation

/**
 * Immutable data object, containing all information needed for the change of the value via bluetooth
 */
class WriteBluetoothValue {

    let deviceName:String
    let serviceName:String
    let characterisicsName:String
    let value:Data
    
    init(_ deviceName:String, _ serviceName:String, _ characteristics: String, _ value:Data) {
        self.deviceName = deviceName
        self.serviceName=serviceName
        self.characterisicsName=characteristics
        self.value = value
    }
    
}
