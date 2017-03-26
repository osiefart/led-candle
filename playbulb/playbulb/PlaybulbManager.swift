//
//  PlaybulbManager.swift
//  playbulb
//
//  Created by Olaf Siefart on 16.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//

import Foundation
import CoreBluetooth

class PlaybulbBluetoothManager {
    
    let LOGGER = Logger("PlaybulbBluetoothManager")
    var bluetoothManager:BluetoothManager!
    
    func changeColor(_ color:String){
        
        if color.characters.count != 12 {
            LOGGER.error("Value \(color) has not length 12")
            exit(0)
        }
        
        /*
         white (seems like saturation)	0x00 (off) .. 0xff (full)
         red	0x00 (off) .. 0xff (full)
         green	0x00 (off) .. 0xff (full)
         blue	0x00 (off) .. 0xff (full)
         */
        
        let whiteRange = color.index(color.startIndex, offsetBy: 0)..<color.index(color.startIndex, offsetBy: 3)
        let white = Int(color[whiteRange])!
        Validate.isInRange(white,0,255)
        
        let redRange = color.index(color.startIndex, offsetBy: 3)..<color.index(color.startIndex, offsetBy: 6)
        let red = Int(color[redRange])!
        Validate.isInRange(red,0,255)
        
        let greenRange = color.index(color.startIndex, offsetBy: 6)..<color.index(color.startIndex, offsetBy: 9)
        let green = Int(color[greenRange])!
        Validate.isInRange(green,0,255)
        
        let blueRange = color.index(color.startIndex, offsetBy: 9)..<color.endIndex
        let blue = Int(color[blueRange])!
        Validate.isInRange(blue,0,255)
        
        let bytes : [UInt8] = [ UInt8(white), UInt8(red), UInt8(green), UInt8(blue)]
        let data  = Data(bytes:bytes)

        
        let value = WriteBluetoothValue("PLAYBULB CANDLE", "FF02", "FFFC", data)
        bluetoothManager = BluetoothManager()
        bluetoothManager.start(value)
    }
    
    
}


class PlaybulbManager {
    
    let LOGGER = Logger("PlaybulbManager")
    let playbulbBluetoothManager = PlaybulbBluetoothManager()
 
    func staticMode() {
        let argument = CommandLine.arguments[1]
        let (option, value) = getOption(argument.substring(from: argument.characters.index(argument.startIndex, offsetBy: 1)))

        switch option {
        case .changeColor:
            playbulbBluetoothManager.changeColor(CommandLine.arguments[2])
        case .help:
            printHelp()
        case .unknown:
            LOGGER.error("Unknown option \(value)")
            printHelp()
        }
        
    }

    func printHelp() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        print("usage:")
        print("\(executableName) -change-color colorString")
        print("or")
        print("\(executableName) -h to show usage information")
        exit(0)
    }

    func getOption(_ option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
}

enum OptionType: String {
    case changeColor = "change-color"
    case help = "h"
    case unknown
    
    init(value: String) {
        switch value {
        case "change-color": self = .changeColor
        case "h": self = .help
        default: self = .unknown
        }
    }
}

