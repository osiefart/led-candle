//
//  BluetoothManager.swift
//  playbulb
//
//  Created by Olaf Siefart on 19.03.17.
//  Copyright © 2017 Olaf Siefart. All rights reserved.
//

import Foundation

import CoreBluetooth

class BluetoothManager:NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    let LOGGER = Logger("BluetoothManager")
    
    var manager:CBCentralManager!
    var peripheral:CBPeripheral!
    var value:WriteBluetoothValue!
    
    func start(_ value:WriteBluetoothValue) {
        manager = CBCentralManager(delegate: self, queue: nil)
        self.value = value
        LOGGER.info("bluetooth successfully initialized")
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == CBCentralManagerState.poweredOn {
            central.scanForPeripherals(withServices: nil, options: nil)
        } else {
            LOGGER.error("Bluetooth not available.")
            exit(0)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name!.contains(value.deviceName) {
            LOGGER.debug("found peripheral named: \(peripheral.name!) : \(RSSI) dBm")
            LOGGER.trace(peripheral)
            self.manager.stopScan()
            self.peripheral = peripheral
            self.peripheral.delegate = self
            LOGGER.debug("connect to \(value.deviceName)")
            manager.connect(peripheral, options: nil)
        } else {
            LOGGER.debug("name: \(peripheral.name) : \(RSSI) dBm does not contain \(value.deviceName)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.discoverServices(nil)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        for service in peripheral.services! {
            let thisService = service as CBService
            
            if thisService.uuid.uuidString.contains(value.serviceName) {
                LOGGER.debug("service \(value.serviceName) found")
                LOGGER.debug("discover characteristics of \(value.serviceName)")
                peripheral.discoverCharacteristics(nil, for: thisService)
                break
            } else {
                LOGGER.trace("service \(thisService.uuid.uuidString) does not contain \(value.serviceName)")
            }
            
        }
    }
    
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for chara in service.characteristics! {
            if chara.uuid.uuidString.contains(value.characterisicsName) {
                LOGGER.debug("found \(value.characterisicsName) in \(chara.uuid) ")
                let data = value.value
                peripheral.writeValue(data, for: chara, type: CBCharacteristicWriteType.withResponse)
                // without reading the value again, we don't get the update listener called
                peripheral.readValue(for: chara)
                break
            } else {
                LOGGER.trace("\(chara.uuid) does not contain \(value.characterisicsName)")
            }
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        LOGGER.debug("updated value in \(characteristic.uuid.uuidString)")
        manager.cancelPeripheralConnection(peripheral)
        LOGGER.debug("close connection to \(peripheral.name!)")
        exit(0)
    }
    
}
