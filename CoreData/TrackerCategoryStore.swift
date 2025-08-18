//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 17/08/25.
//

import CoreData
import UIKit

protocol TrackerCategoryStoreDelegate: AnyObject {
    func newCategoryAdded(insertedIndexes: IndexSet, deletedIndexes: IndexSet, updatedIndexes: IndexSet)
}

final class TrackerCategoryStore: NSObject {
    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects
        else { return [] }
        var result: [TrackerCategory] = []
        do {
            result = try objects.map {
                 try self.convertCategoryFromCoreData(from: $0)
            }
        } catch {return []}
        return result
    }
    
    weak var delegate: TrackerCategoryStoreDelegate?
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    
    private let scheduleConvertor = ScheduleConvertor()
    private let colorConvertor = UIColorMarshalling()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    convenience override init() {
        let context = DataBaseStore.shared.context
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addNewCategory(name: String) throws {
        
        let request  = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), name)
        let count = try context.count(for: request)
        if count == 0 {
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.title = name
            categoryCoreData.trackers = NSSet()
            
            try context.save()
        }
    }
    
    func fetchCategory(name: String) throws -> TrackerCategoryCoreData {
        let trackerCategoryCoreDataRequest = TrackerCategoryCoreData.fetchRequest()
        trackerCategoryCoreDataRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), name)
        let result = try context.fetch(trackerCategoryCoreDataRequest)

        guard let result = result.first else {
            throw CategoryStoreError.fetchingCategoryError
        }
        return result
    }
    
    private func convertCategoryFromCoreData(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        
        guard let title = categoryCoreData.title else {
            throw CategoryStoreError.decodingTitleError
        }
        
        guard let trackersData = categoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw CategoryStoreError.decodingTrackersError
        }
        
        var trackers: [Tracker] = []
        for trackerData in trackersData {
            if
                let id = trackerData.trackerId,
                let name = trackerData.title,
                let emoji = trackerData.emoji,
                let colorString = trackerData.color
            {
                let color = colorConvertor.color(from: colorString)
                let schedule = scheduleConvertor.getSchedule(from: trackerData.schedule)
                let tracker = Tracker(id: id, name: name, color: color, emoji: emoji, schedule: schedule, state: .habit)
                trackers.append(tracker)
            }
        }
        
        return TrackerCategory(title: title, trackers: trackers)
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.newCategoryAdded(insertedIndexes: insertedIndexes!, deletedIndexes: deletedIndexes!, updatedIndexes: updatedIndexes!)
        
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            } else {
                print("⚠️ Ошибка: newIndexPath отсутствует для .insert")
            }
            
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            } else {
                print("⚠️ Ошибка: indexPath отсутствует для .delete")
            }
            
        case .update:
            if let indexPath = indexPath {
                updatedIndexes?.insert(indexPath.item)
            } else {
                print("⚠️ Ошибка: indexPath отсутствует для .update")
            }
            
        case .move:
            if let oldIndexPath = indexPath, let newIndexPath = newIndexPath {
                deletedIndexes?.insert(oldIndexPath.item)
                insertedIndexes?.insert(newIndexPath.item)
            } else {
                print("⚠️ Ошибка: indexPath или newIndexPath отсутствует для .move")
            }
            
        @unknown default:
            print("⚠️ Необработанный тип NSFetchedResultsChangeType: \(type.rawValue)")
        }
    }
}

