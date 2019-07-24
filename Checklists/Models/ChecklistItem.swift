//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

class ChecklistItem {
    var text = ""
    var checked = false

    init(text: String, checked: Bool = false) {
        self.text = text
    }
    
    func toggleChecked() {
        checked.toggle()
    }
}
