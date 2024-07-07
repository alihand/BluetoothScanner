//
//  BluetoothScannerTests.swift
//  BluetoothScannerTests
//
//  Created by Ali Han DEMIR on 2.07.2024.
//

import XCTest
@testable import BluetoothScanner

class BluetoothScannerViewModelTests: XCTestCase {
    var bluetoothScanner: MockBluetoothScanner!
    var delegate: MockBluetoothScannerViewModelDelegate!
    var viewModel: BluetoothScannerViewModel!
    
    override func setUp() {
        super.setUp()
        bluetoothScanner = MockBluetoothScanner()
        delegate = MockBluetoothScannerViewModelDelegate()
        viewModel = BluetoothScannerViewModel(bluetoothScanner: bluetoothScanner, delegate: delegate)
    }
    
    override func tearDown() {
        bluetoothScanner = nil
        delegate = nil
        viewModel = nil
        super.tearDown()
    }
    
    func testToggleScan() {
        XCTAssertFalse(bluetoothScanner.isScanning)
        viewModel.toggleScan()
        XCTAssertTrue(bluetoothScanner.isScanning)
        viewModel.toggleScan()
        XCTAssertFalse(bluetoothScanner.isScanning)
    }
    
    func testGetScanButtonTitle() {
        XCTAssertEqual(viewModel.getScanButtonTitle(), "Start Scanning")
        viewModel.toggleScan()
        XCTAssertEqual(viewModel.getScanButtonTitle(), "Stop Scanning")
    }
    
    func testFilterDevices() {
        let date1 = Date()
        let date2 = Date().addingTimeInterval(10)
        
        bluetoothScanner.simulateDeviceDiscovery(name: "Device1", rssi: -50, timestamp: date1)
        bluetoothScanner.simulateDeviceDiscovery(name: "Device2", rssi: -40, timestamp: date2)
        
        viewModel.filterDevices(with: "Device1")
        XCTAssertEqual(viewModel.filteredDevices.count, 1)
        XCTAssertEqual(viewModel.filteredDevices.first?.name, "Device1")
        
        viewModel.filterDevices(with: "")
        XCTAssertEqual(viewModel.filteredDevices.count, 2)
    }
    
    func testCaseInsentiveDevices() {
        let date1 = Date()
        
        bluetoothScanner.simulateDeviceDiscovery(name: "Device1", rssi: -50, timestamp: date1)
        
        viewModel.filterDevices(with: "DEVICE1")
        XCTAssertEqual(viewModel.filteredDevices.count, 1)
    }
    
    func testDuplicateDevices() {
        let date1 = Date()
        let date2 = Date().addingTimeInterval(10)
        
        bluetoothScanner.simulateDeviceDiscovery(name: "Device1", rssi: -50, timestamp: date1)
        bluetoothScanner.simulateDeviceDiscovery(name: "Device2", rssi: -40, timestamp: date2)
        
        bluetoothScanner.simulateDeviceDiscovery(name: "Device1", rssi: -50, timestamp: date1)
        bluetoothScanner.simulateDeviceDiscovery(name: "Device2", rssi: -40, timestamp: date2)
        
        viewModel.filterDevices(with: "Device1")
        XCTAssertEqual(viewModel.filteredDevices.count, 1)
        XCTAssertEqual(viewModel.filteredDevices.first?.name, "Device1")
        
        viewModel.filterDevices(with: "")
        XCTAssertEqual(viewModel.filteredDevices.count, 2)
    }
    
    func testNotifyDevicesUpdated() {
        viewModel.notifyDevicesUpdated()
        XCTAssertTrue(delegate.didReloadData)
    }
    
    func testDidDiscoverDevice() {
        let date = Date()
        viewModel.didDiscoverDevice(name: "NewDevice", rssi: -60, timestamp: date)
        XCTAssertEqual(viewModel.filteredDevices.count, 1)
        XCTAssertEqual(viewModel.filteredDevices.first?.name, "NewDevice")
    }
    
    func testShowNoDevicesFoundMessage() {
        viewModel.notifyDevicesUpdated()
        XCTAssertTrue(delegate.didShowNoDevicesFoundMessage)
        XCTAssertTrue(delegate.noDevicesFoundMessageParameter)
        
        let date = Date()
        viewModel.didDiscoverDevice(name: "Device1", rssi: -60, timestamp: date)
        viewModel.notifyDevicesUpdated()
        XCTAssertTrue(delegate.didShowNoDevicesFoundMessage)
        XCTAssertFalse(delegate.noDevicesFoundMessageParameter)
        
        viewModel.searchText = "NonExistingDevice"
        viewModel.filterDevices(with: "NonExistingDevice")
        XCTAssertEqual(viewModel.searchText, "NonExistingDevice")
        XCTAssertTrue(delegate.didShowNoDevicesFoundMessage)
        XCTAssertTrue(delegate.noDevicesFoundMessageParameter)
    }
}
