//
//  main.swift
//  playbulb
//
//  Created by Olaf Siefart on 16.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//
import Foundation


print("searching for playbulbs")
var playbulbManager = PlaybulbManager()

if CommandLine.argc < 2 {
    print("wrong number of arguments")
} else {
    playbulbManager.staticMode()
}

dispatchMain()
