//
//  main.swift
//  playbulb
//
//  Created by Olaf Siefart on 16.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//
import Foundation

class Panagram {
    func staticMode() {
        ConsoleIO.printUsage()
    }
}

let panagram = Panagram()
panagram.staticMode()
print("searching for playbulbs")
var playbulbManager = PlaybulbManager()
dispatchMain()
