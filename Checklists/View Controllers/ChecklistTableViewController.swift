//
//  ChecklistTableViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

class ChecklistTableViewController: UITableViewController {
    // MARK: - Properties

    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Methods

    // MARK: - Navigation

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        cell.textLabel?.text = "Hello"
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


}
