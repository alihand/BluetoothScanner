//
//  BluetoothScannerDevice.swift
//  BluetoothScanner
//
//  Created by Ali Han DEMIR on 2.07.2024.
//

import Foundation

struct BluetoothScannerDevice {
    let name: String
    let rssi: Int
    let timestamp: Date
    
    init(name: String, rssi: Int, timestamp: Date) {
        self.name = name
        self.rssi = rssi
        self.timestamp = timestamp
    }
}
