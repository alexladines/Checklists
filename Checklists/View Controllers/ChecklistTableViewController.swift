//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController, ItemDetailTableViewControllerDelegate {

    // MARK: - Properties
    var checklist: Checklist?
    var items = [ChecklistItem]()

    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let checklist = checklist else { return }

        title = checklist.name

        navigationItem.largeTitleDisplayMode = .never

        // Test out data persistance methods
        // print("Documents folder is \(documentsDirectory())")
        // print("Data file path is \(dataFilePath())")

        loadCheckListItems()
    }

    // MARK: - Methods
    // Manages the checkmark on each checklistItem
    func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked {
            label.text = "√"
        }
        else {
            label.text = ""
        }
    }

    // Manages the text for each cell
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let vc = segue.destination as! ItemDetailTableViewController
            vc.delegate = self
        }
        // TIP: Thie segue was created by dragging the cell to the new vc and selecting show from Accessory Action
        else if segue.identifier == "EditItem" {
            let vc = segue.destination as! ItemDetailTableViewController
            vc.delegate = self

            // Get tapped cell's info
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                vc.itemToEdit = items[indexPath.row]
            }
        }
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItemCell", for: indexPath)
        let checklistItem = items[indexPath.row]

        configureText(for: cell, with: checklistItem)
        configureCheckmark(for: cell, with: checklistItem)
        return cell
    }

    // MARK: - UITableViewDelegate
    // When user selects a cell it toggles the checkmark on/off
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveChecklistItems()
    }

    // MARK: - ItemDetailTableViewControllerDelegate
    func itemDetailTableViewControllerDidCancel(_ controller: ItemDetailTableViewController) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishAdding item: ChecklistItem) {
        items.append(item)
        let indexPath = IndexPath(row: items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }

    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: ChecklistItem) {
        // ChecklistItem has to conform to Equatable, we can conform to NSObject to fix this.
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
            saveChecklistItems()
        }

        navigationController?.popViewController(animated: true)
    }

    // MARK: - Data Persistance

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

    // Saving objects to a file
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()

        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }

    // Load items from file
    func loadCheckListItems() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode([ChecklistItem].self, from: data)
            }
            catch {
                print("Error decoding item array :\(error.localizedDescription)")
            }
        }
    }

}
