//
//  CategoriesViewModel.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 25/08/25.
//

import UIKit

protocol CategoryWasSelectedProtocol: AnyObject {
    func categoryWasSelected(category: TrackerCategory)
}

final class CategoriesViewModel {
    private(set) var categories: [CategoryViewModel] = []{
        didSet {
            categoriesBinding?(categories)
        }
    }
    private let categoryStore: TrackerCategoryStore
    
    var categoriesBinding: Binding<[CategoryViewModel]>?
    weak var categoryWasSelectedDelegate: CategoryWasSelectedProtocol?
    var selectedCategory: CategoryViewModel?
    
    convenience init() {
        let categoryStore = try! TrackerCategoryStore(context: DataBaseStore.shared.context)
        self.init(categoryStore: categoryStore)
    }
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        categoryStore.delegate = self
        
        categories = getCategoriesFromStore()
    }
    
    func isLastCategory(index: Int) -> Bool {
        let count = categories.count
        if index == count - 1 {
            return true
        }
        return false
    }
    
    func categoryIsChosen(category: CategoryViewModel?) -> Bool {
        guard let selectedCategory = selectedCategory,
              let category = category
        else {
            return false
        }
        if selectedCategory.title == category.title {
            return true
        }
        return false
        
    }
    
    private func getCategoriesFromStore() -> [CategoryViewModel] {
        return categoryStore.categories.map {
            CategoryViewModel(
                title: $0.title,
                trackers: $0.trackers)
        }
    }
    
    func categoryCellWasTapped(at index: Int) {
        selectedCategory = categories[index]
        if let selectedCategory = selectedCategory {
            categoryWasSelectedDelegate?.categoryWasSelected(category: TrackerCategory(title: selectedCategory.title, trackers: selectedCategory.trackers))
        }
    }
}

extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func newCategoryAdded(insertedIndexes: IndexSet, deletedIndexes: IndexSet, updatedIndexes: IndexSet) {
        categories = getCategoriesFromStore()
    }
}
