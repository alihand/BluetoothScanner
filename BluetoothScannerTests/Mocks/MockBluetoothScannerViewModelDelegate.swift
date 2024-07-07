//
//  MockBluetoothScannerViewModelDelegate.swift
//  BluetoothScanner
//
//  Created by Ali Han DEMIR on 7.07.2024.
//

import Foundation
@testable import BluetoothScanner

class MockBluetoothScannerViewModelDelegate: BluetoothScannerViewModelDelegate {
    var didReloadData = false
    var didShowNoDevicesFoundMessage = false
    var noDevicesFoundMessageParameter = false
    
    func reloadData() {
        didReloadData = true
    }
    
    func showNoDevicesFoundMessage(_ show: Bool) {
        didShowNoDevicesFoundMessage = true
        noDevicesFoundMessageParameter = show
    }
}
