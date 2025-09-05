//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 25/08/25.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel {
    let title: String
    let trackers: [Tracker]
    
    var titleBinding: Binding<String>? {
        didSet {
            titleBinding?(title)
        }
    }
    var trackersBinding: Binding<[Tracker]>? {
        didSet {
            trackersBinding?(trackers)
        }
    }
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}
