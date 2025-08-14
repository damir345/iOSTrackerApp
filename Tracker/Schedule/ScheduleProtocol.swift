//
//  ScheduleProtocol.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 1/08/25.
//

import Foundation

protocol ScheduleProtocol: AnyObject {
    func saveSelectedDays(selectedDays: Set<WeekDays>)
}
