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
    var text = ""
    var checked = false

    init(text: String, checked: Bool = false) {
        self.text = text
        super.init()
    }
    
    func toggleChecked() {
        checked.toggle()
    }
}
