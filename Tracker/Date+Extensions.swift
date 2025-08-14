//
//  Date+Extensions.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 31/07/25.
//

import Foundation

extension Date {
    var stripTime: Date {
       Calendar.current.startOfDay(for: self)
    }
}
