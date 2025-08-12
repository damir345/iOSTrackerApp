//
//  TrackerModel.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 11/08/25.
//

import UIKit

class TrackerModel: TrackerCounterDelegate
{
    lazy var currentCategories: [TrackerCategory] = {
        filterCategoriesToshow()
    }()

    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    
    //sampleData
//    init() {
//       let sampleData = TrackerSampleData()
//       sampleData.createSampleData()
//
//       self.categories = sampleData.categories
//       self.completedTrackers = sampleData.completedTrackers
//    }

    private func filterCategoriesToshow() -> [TrackerCategory] {
        currentCategories = []
        let weekdayInt = Calendar.current.component(.weekday, from: currentDate)
        let day = (weekdayInt == 1) ?  WeekDays(rawValue: 7) : WeekDays(rawValue: weekdayInt - 1)
        
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.schedule.contains(day!)
            }
            
            if trackers.count > 0 {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        return currentCategories
    }
    
    //MARK: - TrackerCounterDelegate +
    func calculateTimesTrackerWasCompleted(trackerId: UUID) -> Int {
        let contains = completedTrackers.filter {
            $0.id == trackerId
        }
        return contains.count
    }
    
    func checkIfTrackerWasCompletedAtCurrentDay(trackerId: UUID, date: Date) -> Bool {
        let contains = completedTrackers.filter {
            ($0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day))
        }.count > 0
        return contains
    }
    
    func increaseTrackerCounter(trackerId: UUID, date: Date) {
        completedTrackers.append(TrackerRecord(id: trackerId, date: date))
    }
    
    func decreaseTrackerCounter(trackerId: UUID, date: Date) {
        completedTrackers = completedTrackers.filter {
            if $0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day) {
                return false
            }
            return true
        }
    }
    //MARK: - TrackerCounterDelegate -

     //TODO: change func name
     func updateCollectionAccordingToSearchBarResults(enteredName: String) {
        currentCategories = []
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.name.contains(enteredName)
            }
            
            if trackers.count > 0 {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
    }

     //TODO: change func name
    func updateCollectionAccordingToDate() {
        currentCategories = filterCategoriesToshow()
    }

    //+ TrackerCreationDelegate
    func createTracker(tracker: Tracker, category: String) {
        let categoryFound = categories.filter{
            $0.title == category
        }
        
        var trackers: [Tracker] = []
        if categoryFound.count > 0 {
            categoryFound.forEach{
                trackers = trackers + $0.trackers
            }
            trackers.append(tracker)
            categories = categories.filter{
                $0.title != category
            }
            if !trackers.isEmpty {
                categories.append(TrackerCategory(title: category, trackers: trackers))
            }
        } else {
            categories.append(TrackerCategory(title: category, trackers: [tracker]))
        }
        updateCollectionAccordingToDate()
    }
    //-
}
