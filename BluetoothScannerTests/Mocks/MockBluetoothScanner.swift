//
//  MockBluetoothScanner.swift
//  BluetoothScanner
//
//  Created by Ali Han DEMIR on 7.07.2024.
//

import Foundation
@testable import BluetoothScanner
import BluetoothScannerLibrary

class MockBluetoothScanner: BluetoothScannerProtocol {
    weak var delegate: BluetoothScannerDelegate?
    var isScanning: Bool = false
    
    func startScanning() {
        isScanning = true
    }
    
    func stopScanning() {
        isScanning = false
    }
    
    func simulateDeviceDiscovery(name: String, rssi: Int, timestamp: Date) {
        delegate?.didDiscoverDevice(name: name, rssi: rssi, timestamp: timestamp)
    }
}
