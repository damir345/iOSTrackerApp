//
//  TrackerModel.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 11/08/25.
//

import UIKit

final class TrackerModel: TrackerCounterDelegate {
    // MARK: - Stores
    private let trackerStore = TrackerStore()
    private let categoryStore = TrackerCategoryStore()
    private let recordStore = TrackerRecordStore()
    
    // MARK: - Data
    lazy var currentCategories: [TrackerCategory] = {
        filterCategoriesToShow()
    }()
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var currentDate = Date()
    
    // MARK: - Init
    init() {
        //DataBaseStore.shared.resetAllData()
        loadData()
    }
    
    private func loadData() {
        // Загружаем категории из CoreData
        categories = categoryStore.categories
        completedTrackers = recordStore.completedTrackers
        currentCategories = filterCategoriesToShow()
    }
    
    // MARK: - Filtering
    private func filterCategoriesToShow() -> [TrackerCategory] {
        currentCategories = []
        
        let weekdayInt = Calendar.current.component(.weekday, from: currentDate)
        let dayIndex = (weekdayInt == 1) ? 7 : weekdayInt - 1
        guard let day = WeekDays(rawValue: dayIndex) else {
            return currentCategories // возвращаем пустой массив, если день некорректный
        }
        
        for category in categories {
            let trackers = category.trackers.filter { $0.schedule.contains(day) }
            
            if !trackers.isEmpty {
                currentCategories.append(TrackerCategory(title: category.title, trackers: trackers))
            }
        }
        return currentCategories
    }
    
    // MARK: - TrackerCounterDelegate
    func calculateTimesTrackerWasCompleted(trackerId: UUID) -> Int {
        completedTrackers.filter { $0.id == trackerId }.count
    }
    
    func checkIfTrackerWasCompletedAtCurrentDay(trackerId: UUID, date: Date) -> Bool {
        completedTrackers.contains {
            $0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day)
        }
    }
    
    func increaseTrackerCounter(trackerId: UUID, date: Date) {
        do {
            try recordStore.addRecord(trackerId: trackerId, date: date)
            completedTrackers = recordStore.completedTrackers
        } catch {
            print("❌ Ошибка при добавлении записи: \(error)")
        }
    }
    
    func decreaseTrackerCounter(trackerId: UUID, date: Date) {
        do {
            try recordStore.deleteRecord(trackerId: trackerId, date: date)
            completedTrackers = recordStore.completedTrackers
        } catch {
            print("❌ Ошибка при удалении записи: \(error)")
        }
    }
    
    // MARK: - Search & Date Update
    func updateCollectionAccordingToSearchBarResults(enteredName: String) {
        currentCategories = []
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.name.localizedCaseInsensitiveContains(enteredName)
            }
            
            if !trackers.isEmpty {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
    }
    
    func updateCollectionAccordingToDate() {
        currentCategories = filterCategoriesToShow()
    }
    
    // MARK: - TrackerCreationDelegate
    func createTracker(tracker: Tracker, category: String) {
        do {
            try trackerStore.addNewTracker(tracker: tracker, forCategory: category)
            // обновляем локальные данные после сохранения
            categories = categoryStore.categories
            updateCollectionAccordingToDate()
        } catch {
            print("❌ Ошибка при сохранении трекера: \(error)")
        }
    }
}
