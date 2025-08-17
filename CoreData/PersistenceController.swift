//
//  PersistenceController.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 17/08/25.
//

import CoreData

final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    private init() {
        // Указываем имя модели (.xcdatamodeld)
        container = NSPersistentContainer(name: "Tracker")

        // Здесь можно добавить несколько Store, например SQLite + In-Memory
        let storeDescriptions: [NSPersistentStoreDescription] = [
            // SQLite (основное хранилище)
            NSPersistentStoreDescription(url: Self.defaultURL()),
            
            // In-Memory (для тестов)
            {
                let description = NSPersistentStoreDescription()
                description.type = NSInMemoryStoreType
                return description
            }(),
            
            // Binary (пример третьего типа хранилища)
            {
                let description = NSPersistentStoreDescription()
                description.type = NSBinaryStoreType
                description.url = Self.binaryURL()
                return description
            }()
        ]

        container.persistentStoreDescriptions = storeDescriptions

        // Загружаем Store
        container.loadPersistentStores { description, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            } else {
                print("✅ Loaded store: \(description.type)")
            }
        }

        // Опционально: автообъединение изменений между контекстами
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    // MARK: - Вспомогательные методы для URL
    private static func defaultURL() -> URL {
        let storeURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("Tracker.sqlite")
        return storeURL
    }

    private static func binaryURL() -> URL {
        let storeURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first!
            .appendingPathComponent("TrackerBinary")
        return storeURL
    }

    // MARK: - Удобный доступ к context
    var context: NSManagedObjectContext {
        container.viewContext
    }

    // MARK: - Метод сохранения
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
