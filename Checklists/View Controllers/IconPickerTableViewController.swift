//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/30/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

protocol IconPickerTableViewControllerDelegate: class {
    func iconPickerTableViewController(_ picker: IconPickerTableViewController, didPick iconName: String)
}

class IconPickerTableViewController: UITableViewController {
    // MARK: - Properties
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores",
                  "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]

    weak var delegate: IconPickerTableViewControllerDelegate?

    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle

    // MARK: - Methods

    // MARK: - Navigation

    // MARK: - Data Persistance

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)
        let iconName = icons[indexPath.row]
        cell.textLabel!.text = iconName
        cell.imageView!.image = UIImage(named: iconName) // Default style also comes with an imageView
        return cell
    }
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else { return }
        let iconName = icons[indexPath.row]
        delegate.iconPickerTableViewController(self, didPick: iconName)
    }

}
