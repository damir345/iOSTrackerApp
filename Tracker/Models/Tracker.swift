//
//  Tracker.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 28/07/25.
//

import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDays>
    let state: State

    init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, schedule: Set<WeekDays>, state: State) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.state = state
    }
}

