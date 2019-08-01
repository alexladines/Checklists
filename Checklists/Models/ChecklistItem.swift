//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

// Need the NSObject to use index(of:) on arrays of this object.
// Codable combines Encodable and Decodable protocols.
class ChecklistItem : NSObject, Codable {

    // MARK: - Properties
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1


    // MARK: - Methods
    init(text: String, checked: Bool = false) {
        self.text = text
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }

    func toggleChecked() {
        checked.toggle()
    }

    // MARK: - Codable

    // MARK: - Equatable

    // MARK: - Core Data

    // MARK: - UserDefaults

    // MARK: - Data Persistance
}
