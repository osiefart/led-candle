//
//  ConsoleIO.swift
//  playbulb
//
//  Created by Olaf Siefart on 16.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//

import Foundation

class ConsoleIO {
    class func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        print("usage:")
        print("\(executableName) -a string1 string2")
        print("or")
        print("\(executableName) -p string")
        print("or")
        print("\(executableName) -h to show usage information")
        print("Type \(executableName) without an option to enter interactive mode.")
    }
    
    func getOption(_ option: String) -> (option:OptionType, value: String) {
        return (OptionType(value: option), option)
    }
    
    enum OptionType: String {
        case palindrome = "p"
        case anagram = "a"
        case help = "h"
        case unknown
        
        init(value: String) {
            switch value {
            case "a": self = .anagram
            case "p": self = .palindrome
            case "h": self = .help
            default: self = .unknown
            }
        }
    }

}

