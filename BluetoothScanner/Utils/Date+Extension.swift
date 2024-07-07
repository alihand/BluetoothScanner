//
//  Date+Extension.swift
//  BluetoothScanner
//
//  Created by Ali Han DEMIR on 5.07.2024.
//

import Foundation

extension Date {
    func toReadableString() -> String {
        let readableDateFormatter = DateFormatter()
        readableDateFormatter.dateStyle = .full
        readableDateFormatter.timeStyle = .short
        readableDateFormatter.timeZone = TimeZone.current

        return readableDateFormatter.string(from: self)
    }
}
