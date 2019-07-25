//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    // MARK: - Properties

    // MARK: - IBOutlets

    // MARK: - IBActions
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        
    }

    // MARK: - Methods

    // MARK: - Navigation

    // MARK: - UITableViewDataSource

    // MARK: - UITableViewDelegate

}
