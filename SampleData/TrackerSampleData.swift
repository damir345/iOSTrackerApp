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
                schedule: [.monday, .wednesday, .friday], state: .habit
            ),
            Tracker(
                name: "Drink Water", color: colors[1], emoji: "💧",
                schedule: [.tuesday, .thursday], state: .event
            )
        ]
        categories.append(TrackerCategory(title: "Здоровье", trackers: healthTrackers))
    
        // 2. Work Category
        let workTrackers = [
            Tracker(
                name: "Read Email", color: colors[2], emoji: "📧",
                schedule: [.monday, .tuesday, .wednesday], state: .habit
            ),
            Tracker(
                name: "Code Review", color: colors[3], emoji: "💻",
                schedule: [.thursday, .friday], state: .event
            )
        ]
        categories.append(TrackerCategory(title: "Работа", trackers: workTrackers))
    
        // 3. Hobbies Category
        let hobbiesTrackers = [
            Tracker(
                name: "Read Book", color: colors[4], emoji: "📚",
                schedule: [.saturday, .sunday], state: .habit
            ),
            Tracker(
                name: "Play Guitar", color: colors[5], emoji: "🎸",
                schedule: [.monday, .wednesday], state: .event
            )
        ]
        categories.append(TrackerCategory(title: "Хобби", trackers: hobbiesTrackers))
    
        // 4. Finance Category
        let financeTrackers = [
            Tracker(
                name: "Budget Check", color: colors[6], emoji: "💰",
                schedule: [.friday], state: .habit
            )
        ]
        categories.append(TrackerCategory(title: "Финансы", trackers: financeTrackers))
    
        // 5. Personal Category
        let personalTrackers = [
            Tracker(
                name: "Meditate", color: colors[0], emoji: "🧘",
                schedule: [.sunday], state: .event
            ),
            Tracker(
                name: "Journal", color: colors[1], emoji: "📖",
                schedule: [.monday, .wednesday, .friday], state: .habit
            )
        ]
        categories.append(TrackerCategory(title: "Личное", trackers: personalTrackers))
    
        // Индексы категорий и сколько дней назад завершён трекер
        let completedTrackerConfigs: [(categoryIndex: Int, daysAgo: Int)] = [
            (0, 1),
            (1, 2),
            (2, 3),
            (3, 7),
            (4, 14)
        ]

        completedTrackers = completedTrackerConfigs.compactMap { config in
            guard categories.indices.contains(config.categoryIndex),
                  categories[config.categoryIndex].trackers.indices.contains(0),
                  let date = Calendar.current.date(byAdding: .day, value: -config.daysAgo, to: Date())
            else {
                return nil
            }
            
            return TrackerRecord(
                id: categories[config.categoryIndex].trackers[0].id,
                date: date
            )
        }
    
        // Assign to your model or view controller
        self.categories = categories
        self.completedTrackers = completedTrackers
    }

}
