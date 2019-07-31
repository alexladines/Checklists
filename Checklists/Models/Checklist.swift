//
//  Checklist.swift
//  Checklists
//
//  Created by Alex Ladines on 7/25/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

class Checklist: NSObject, Codable {
    // MARK: - Properties
    var name = ""
    var items = [ChecklistItem]()
    // Names will be from Assets.xcassets
    var iconName = "No Icon"

    // MARK: - Methods
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }

    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count = count + 1
        }

        return count
    }

    // MARK: - Codable

    // MARK: - Equatable

    // MARK: - Core Data

    // MARK: - UserDefaults

    // MARK: - Data Persistance


}
