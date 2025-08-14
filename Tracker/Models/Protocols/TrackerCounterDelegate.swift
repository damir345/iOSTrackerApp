//
//  TrackerCollectionDelegate.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 1/08/25.
//

import Foundation

protocol TrackerCounterDelegate: AnyObject {
    func increaseTrackerCounter(trackerId: UUID, date: Date)
    func decreaseTrackerCounter(trackerId: UUID, date: Date)
    func checkIfTrackerWasCompletedAtCurrentDay(trackerId: UUID, date: Date) -> Bool
    func calculateTimesTrackerWasCompleted(trackerId: UUID) -> Int
}
