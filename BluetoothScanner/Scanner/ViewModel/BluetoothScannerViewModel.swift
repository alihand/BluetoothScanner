//
//  BluetoothScannerViewModel.swift
//  BluetoothScanner
//
//  Created by Ali Han DEMIR on 2.07.2024.
//

import Foundation
import BluetoothScannerLibrary

protocol BluetoothScannerViewModelDelegate: AnyObject {
    func reloadData()
    func showNoDevicesFoundMessage(_ show: Bool)
}

final class BluetoothScannerViewModel {
    private let bluetoothScanner: BluetoothScannerProtocol
    private var devicesDict: [String: BluetoothScannerDevice] = [:]
    var filteredDevices: [BluetoothScannerDevice] = []
    var searchText: String = ""
    
    private weak var delegate: BluetoothScannerViewModelDelegate?
    
    init(bluetoothScanner: BluetoothScannerProtocol, delegate: BluetoothScannerViewModelDelegate) {
        self.bluetoothScanner = bluetoothScanner
        self.bluetoothScanner.delegate = self
        self.delegate = delegate
    }
    
    func toggleScan() {
        if bluetoothScanner.isScanning {
            bluetoothScanner.stopScanning()
        } else {
            bluetoothScanner.startScanning()
        }
        notifyDevicesUpdated()
    }
    
    func filterDevices(with searchText: String) {
        let devices = Array(devicesDict.values)
        if !searchText.isEmpty {
            filteredDevices = devices.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        } else {
            filteredDevices = devices
        }
        filteredDevices.sort { $0.timestamp < $1.timestamp }
        notifyDevicesUpdated()
    }
    
    func getScanButtonTitle() -> String {
        return bluetoothScanner.isScanning ? "Stop Scanning" : "Start Scanning"
    }
    
    func notifyDevicesUpdated() {
        delegate?.reloadData()
        delegate?.showNoDevicesFoundMessage(filteredDevices.isEmpty)
    }
}
//MARK: -BluetoothScannerDelegate
extension BluetoothScannerViewModel: BluetoothScannerDelegate {
    func didDiscoverDevice(name: String, rssi: Int, timestamp: Date) {
        let newDevice = BluetoothScannerDevice(name: name, rssi: rssi, timestamp: timestamp)
        devicesDict[name] = newDevice
        filterDevices(with: searchText)
    }
}
