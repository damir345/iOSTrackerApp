//
//  DataBaseStore.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 18/08/25.
//

import CoreData

final class DataBaseStore {
    static let shared = DataBaseStore()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("❌ Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("❌ Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func resetAllData() {
        let storeCoordinator = persistentContainer.persistentStoreCoordinator
        
        for store in storeCoordinator.persistentStores {
            if let storeURL = store.url {
                do {
                    try storeCoordinator.destroyPersistentStore(
                        at: storeURL,
                        ofType: store.type,
                        options: nil
                    )
                } catch {
                    print("❌ Ошибка при удалении хранилища: \(error)")
                }
            }
        }
        
        // Перезапуск контейнера
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                print("❌ Ошибка повторной загрузки persistent stores: \(error)")
            } else {
                print("✅ CoreData успешно очищена и перезапущена")
            }
        }
    }
}
