//
//  PlaybulbManager.swift
//  playbulb
//
//  Created by Olaf Siefart on 16.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//

import Foundation
import CoreBluetooth

class PlaybulbManager:
    NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    var searchedDeviceName:String!
    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self, queue: nil)
        searchedDeviceName = "Candle"
        print("bluetooth successfully initialized")
        
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBCentralManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            print("Bluetooth not available.")
            exit(0)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if peripheral.name!.contains(searchedDeviceName) {
            print("name: \(peripheral.name) : \(RSSI) dBm")
            print(peripheral)
            
            self.manager.stopScan()
            
            self.peripheral = peripheral
            self.peripheral.delegate = self
            
            manager.connect(peripheral, options: nil)
            
            
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            print("service: " , thisService.uuid)
            print(thisService.uuid.uuidString)
            
            if thisService.uuid.uuidString.contains("FF02") {
                print("service ff02 found")
                peripheral.discoverCharacteristics(nil, for: thisService)
                //thisService.setValue("ff00000004000000", forKey: "FFFC")
            }
            
        }
    }
    

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("charakcteristics:", service.characteristics)

        for chara in service.characteristics! {
            print("chara.uuid: ",chara.uuid)
            
            if chara.uuid.uuidString.contains("FFFC") {

                let bytes : [UInt8] = [ 0x0, 0x0, 0x0, 0x0]
                let data = Data(bytes:bytes)
                
                peripheral.writeValue(data, for: chara, type: CBCharacteristicWriteType.withResponse)
                print("changed")
                // without reading the value again, we don't get the update listener called
                peripheral.readValue(for: chara)
            }
        }

        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("value updated")
        manager.cancelPeripheralConnection(peripheral)
        exit(0)
    }

    
    
}

