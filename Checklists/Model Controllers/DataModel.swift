//
//  DataModel.swift
//  Checklists
//
//  Created by Alex Ladines on 7/29/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation

// We serialize Checklist objects, not DataModel objects hence no :NSObject, Codable
// Do not need super.init for same reason as above
class DataModel {
    var lists = [Checklist]()

    init() {
        loadChecklists()
    }

    // MARK: - Data Persistance
    // ⌘+Shift+G -> To find a file in finder. Remove the "file://"
    // print("Documents folder is \(documentsDirectory())")
    // print("Data file path is \(dataFilePath())")
    
    // Testing data persistance
    // Run the app and make some changes to the to-do items. Press Stop to terminate the app. Start it again and notice that your changes are still there.
    // Stop the app again. Go to the Finder window with the Documents folder and remove the Checklists.plist file. Run the app once more. You should now have an empty list of items.
    // Add an item and notice that the Checklists.plist file re-appears.
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding list array: \(error.localizedDescription)")
        }
    }

    func loadChecklists() {
        let path = dataFilePath()

        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                lists = try decoder.decode([Checklist].self, from: data)
            }
            catch {
                print("Error decoding list array : \(error.localizedDescription)")
            }
        }
    }
}