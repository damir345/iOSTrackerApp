//
//  TrackerSampleData.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 12/08/25.
//

import UIKit

final class TrackerSampleData {
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []

    // MARK: - Sample Data Creation
    func createSampleData() {

        var categories: [TrackerCategory] = []
        var completedTrackers: [TrackerRecord] = []

        // Define reusable colors
        let colors: [UIColor] = [
            .systemRed, .systemGreen, .systemBlue, .systemYellow,
            .systemPurple, .systemOrange, .systemTeal
        ]
     
        // 1. Health Category
        let healthTrackers = [
            Tracker(
                name: "Morning Run", color: colors[0], emoji: "🏃",
                schedule: [.monday, .wednesday, .friday], state: .Habit
            ),
            Tracker(
                name: "Drink Water", color: colors[1], emoji: "💧",
                schedule: [.tuesday, .thursday], state: .Event
            )
        ]
        categories.append(TrackerCategory(title: "Здоровье", trackers: healthTrackers))
    
        // 2. Work Category
        let workTrackers = [
            Tracker(
                name: "Read Email", color: colors[2], emoji: "📧",
                schedule: [.monday, .tuesday, .wednesday], state: .Habit
            ),
            Tracker(
                name: "Code Review", color: colors[3], emoji: "💻",
                schedule: [.thursday, .friday], state: .Event
            )
        ]
        categories.append(TrackerCategory(title: "Работа", trackers: workTrackers))
    
        // 3. Hobbies Category
        let hobbiesTrackers = [
            Tracker(
                name: "Read Book", color: colors[4], emoji: "📚",
                schedule: [.saturday, .sunday], state: .Habit
            ),
            Tracker(
                name: "Play Guitar", color: colors[5], emoji: "🎸",
                schedule: [.monday, .wednesday], state: .Event
            )
        ]
        categories.append(TrackerCategory(title: "Хобби", trackers: hobbiesTrackers))
    
        // 4. Finance Category
        let financeTrackers = [
            Tracker(
                name: "Budget Check", color: colors[6], emoji: "💰",
                schedule: [.friday], state: .Habit
            )
        ]
        categories.append(TrackerCategory(title: "Финансы", trackers: financeTrackers))
    
        // 5. Personal Category
        let personalTrackers = [
            Tracker(
                name: "Meditate", color: colors[0], emoji: "🧘",
                schedule: [.sunday], state: .Event
            ),
            Tracker(
                name: "Journal", color: colors[1], emoji: "📖",
                schedule: [.monday, .wednesday, .friday], state: .Habit
            )
        ]
        categories.append(TrackerCategory(title: "Личное", trackers: personalTrackers))
    
        // Create TrackerRecords (Completed Trackers)
        completedTrackers = [
            TrackerRecord(id: categories[0].trackers[0].id, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
            TrackerRecord(id: categories[1].trackers[0].id, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
            TrackerRecord(id: categories[2].trackers[0].id, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
            TrackerRecord(id: categories[3].trackers[0].id, date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!),
            TrackerRecord(id: categories[4].trackers[0].id, date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!)
        ]
    
        // Assign to your model or view controller
        self.categories = categories
        self.completedTrackers = completedTrackers
    }

}
