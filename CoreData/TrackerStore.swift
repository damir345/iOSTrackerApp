//
//  TrackerStore.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 17/08/25.
//

import CoreData
import UIKit

protocol TrackerStoreDelegate: AnyObject {
    func store(insertedIndexes: [IndexPath], deletedIndexes: IndexSet)
}

final class TrackerStore: NSObject {
    weak var delegate: TrackerStoreDelegate?
    
    private let context: NSManagedObjectContext
    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: IndexSet?
    
    private let uiColorMarshalling = UIColorMarshalling()
    private let scheduleConvertor = ScheduleConvertor()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)
        ]
        
        let frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        frc.delegate = self
        try? frc.performFetch()
        return frc
    }()
    
    convenience override init() {
        let context = DataBaseStore.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Add New Tracker
    func addNewTracker(tracker: Tracker, forCategory category: String) throws {
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        var categoryData: TrackerCategoryCoreData
        
        do {
            categoryData = try trackerCategoryStore.fetchCategory(name: category)
        } catch {
            categoryData = TrackerCategoryCoreData(context: context)
            categoryData.title = category
            try context.save()
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.title = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleConvertor.convertScheduleToUInt16(from: tracker.schedule)
        trackerCoreData.category = categoryData
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    // MARK: - Fetch Tracker by ID
    func fetchTracker(trackerId: UUID) throws -> TrackerCoreData {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), trackerId as CVarArg)
        
        let result = try context.fetch(request)
        guard let tracker = result.first else {
            throw TrackerStoreError.fetchingTrackerError
        }
        return tracker
    }
    
    // MARK: - Delete Tracker
    func deleteTracker(tracker: TrackerCoreData) throws {
        context.delete(tracker)
        if context.hasChanges {
            try context.save()
        }
    }
    
    // MARK: - Fetch Trackers for Category
    func fetchTrackers(forCategory category: String) throws -> [TrackerCoreData] {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "category.title == %@", category)
        return try context.fetch(request)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(insertedIndexes: insertedIndexes ?? [], deletedIndexes: deletedIndexes ?? [])
        insertedIndexes?.removeAll()
        deletedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.append(indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        @unknown default:
            break
        }
    }
}
