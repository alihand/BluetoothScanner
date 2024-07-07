//
//  BluetoothScannerProtocol.swift
//  BluetoothScanner
//
//  Created by Ali Han DEMIR on 7.07.2024.
//

import Foundation
import BluetoothScannerLibrary

protocol BluetoothScannerProtocol: AnyObject {
    var isScanning: Bool { get }
    var delegate: BluetoothScannerDelegate? { get set }
    func startScanning()
    func stopScanning()
}

extension BluetoothScanner: BluetoothScannerProtocol {}
