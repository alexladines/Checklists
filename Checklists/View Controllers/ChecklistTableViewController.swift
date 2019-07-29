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
    var checklist: Checklist!


    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let checklist = checklist else { return }

        title = checklist.name

        navigationItem.largeTitleDisplayMode = .never

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
                vc.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItemCell", for: indexPath)
        let checklistItem = checklist.items[indexPath.row]

        configureText(for: cell, with: checklistItem)
        configureCheckmark(for: cell, with: checklistItem)
        return cell
    }

    // MARK: - UITableViewDelegate
    // When user selects a cell it toggles the checkmark on/off
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmark(for: cell, with: item)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // MARK: - ItemDetailTableViewControllerDelegate
    func itemDetailTableViewControllerDidCancel(_ controller: ItemDetailTableViewController) {
        navigationController?.popViewController(animated: true)
    }

    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishAdding item: ChecklistItem) {
        checklist.items.append(item)
        let indexPath = IndexPath(row: checklist.items.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }

    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: ChecklistItem) {
        // ChecklistItem has to conform to Equatable, we can conform to NSObject to fix this.
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }

        navigationController?.popViewController(animated: true)
    }

}
