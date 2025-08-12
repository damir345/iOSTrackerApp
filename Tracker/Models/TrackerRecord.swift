//
//  TrackerRecord.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 28/07/25.
//

import Foundation

struct TrackerRecord {
    let id: UUID
    let date: Date
    
    init(id: UUID, date: Date) {
        self.id = id
        self.date = date
    }
}
