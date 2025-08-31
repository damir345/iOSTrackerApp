//
//  UserDefaultsService.swift
//  Tracker
//
//  Created by Damir Salakhetdinov on 31/08/25.
//

import Foundation

final class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let defaults = UserDefaults.standard
    
    private init() {}
    
    private enum Key {
        static let notFirstInApp = "notFirstInApp"
    }
    
    var isNotFirstInApp: Bool {
        get { defaults.bool(forKey: Key.notFirstInApp) }
        set { defaults.set(newValue, forKey: Key.notFirstInApp) }
    }
    
    func reset() {
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
            defaults.synchronize()
        }
    }
}
