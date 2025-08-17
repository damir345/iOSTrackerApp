//
//  CategoryStoreError.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 17/08/25.
//

import Foundation

enum CategoryStoreError: Error {
    case decodingTitleError
    case decodingTrackersError
    case fetchingCategoryError
}
