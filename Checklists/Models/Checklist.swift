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

    // MARK: - Methods
    init(name: String) {
        self.name = name
        super.init()
    }

    // MARK: - Codable

    // MARK: - Equatable

    // MARK: - Core Data

    // MARK: - UserDefaults

    // MARK: - Data Persistance


}
