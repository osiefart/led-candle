//
//  Logger.swift
//  playbulb
//
//  Created by Olaf Siefart on 19.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//

import Foundation


class Logger {
    
    // define loglevel: 1=trace, 2=debug, 3=info, 4=warn, 5=error
    let logLevel:Int = 2
    let loggerName: String
    
    init(_ loggerName: String ) {
        self.loggerName = loggerName
    }

    
    func trace(_ items: Any...) {
        if (logLevel <= 1) {
            print("\u{001B}[;m\(loggerName): ", items)
        }
    }

    func debug(_ items: Any...) {
        if (logLevel <= 2) {
            print("\u{001B}[;m\(loggerName): ", items)
        }
    }
    
    func info(_ items: Any...) {
        if (logLevel <= 3) {
            print("\u{001B}[;m\(loggerName): ", items)
        }

    }
    
    func warn(_ items: Any...) {
        if (logLevel <= 4) {
            print("\u{001B}[;m\(loggerName): ", items)
        }

    }
    
    func error(_ message: String) {
        if (logLevel <= 5) {
            fputs("\u{001B}[0;31m\(loggerName): \(message)\n", stderr)
        }
    }
    
}
