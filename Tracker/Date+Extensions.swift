//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 31/07/25.
//

import Foundation

extension Date {
    func stripTime() -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
}
