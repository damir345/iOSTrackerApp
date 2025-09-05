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
        let categoryStore = TrackerCategoryStore(context: DataBaseStore.shared.context)
        self.init(categoryStore: categoryStore)
    }
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        categoryStore.delegate = self
        
        categories = getCategoriesFromStore()
    }
    
    func isLastCategory(index: Int) -> Bool {
        index == categories.count - 1
    }
    
    func categoryIsChosen(category: CategoryViewModel?) -> Bool {
        selectedCategory?.title == category?.title
    }
    
    private func getCategoriesFromStore() -> [CategoryViewModel] {
        categoryStore.categories.map {
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
