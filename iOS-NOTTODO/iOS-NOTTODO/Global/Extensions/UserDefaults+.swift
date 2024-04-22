//
//  UserDefaults+.swift
//  iOS-NOTTODO
//
//  Created by 강윤서 on 4/22/24.
//

import Foundation
import WidgetKit

extension UserDefaults {
    static var shared: UserDefaults? {
        return UserDefaults(suiteName: Bundle.main.appGroups)
    }
    
    func setSharedCustomArray<T: Codable>(_ value: [T], forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: key)
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func getSharedCustomArray<T: Codable>(forKey key: String) -> [T]? {
        if let savedData = self.object(forKey: key) as? Data {
            if let savedObject = try? JSONDecoder().decode([T].self, from: savedData) {
                return savedObject
            }
        }
        return nil
    }
}
