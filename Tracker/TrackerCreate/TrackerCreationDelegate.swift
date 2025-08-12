//
//  TrackerCreationDelegate.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 1/08/25.
//

import Foundation

protocol TrackerCreationDelegate: AnyObject {
    func createTracker(tracker: Tracker, category: String)
}
