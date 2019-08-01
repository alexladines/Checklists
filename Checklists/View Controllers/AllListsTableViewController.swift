//
//  AllListsTableViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/25/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

class AllListsTableViewController: UITableViewController, ListDetailTableViewControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Properties
    let cellIdentifier = "ChecklistCell"
    var dataModel: DataModel!

    // MARK: - IBOutlets

    // MARK: - IBActions

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // After VC becomes visible
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        title = "Checklists"
        navigationController?.navigationBar.prefersLargeTitles = true

    }

    // MARK: - Methods

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let vc = segue.destination as! ChecklistTableViewController
            vc.checklist = sender as? Checklist
        }
        else if segue.identifier == "AddChecklist" {
            let vc = segue.destination as! ListDetailTableViewController
            vc.delegate = self
        }
    }


    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    // Making the cells by code instead of storyboard prototypes just to learn how to do it.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell!
        if let dequeuedCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = dequeuedCell
        }
        else {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
        // Returns a default style cell and use of the subtitle will crash the app
        // let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.textLabel!.font = UIFont.systemFont(ofSize: 17)
        cell.imageView?.image = UIImage(named: checklist.iconName) //Subtitle style comes with an imageView
        cell.accessoryType = .detailDisclosureButton
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        }
        else {
            cell.detailTextLabel!.text = count == 0 ? "All Done!" : "\(count) Remaining"
        }

        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Open the last checklist upon starting app
        dataModel.indexOfSelectedChecklist = indexPath.row
        performSegue(withIdentifier: "ShowChecklist", sender: dataModel.lists[indexPath.row])
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // Instead of using a segue we can load the vc from code. Multiple ways of doing the same thing.
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "ListDetailTableViewController") as! ListDetailTableViewController
        vc.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        vc.checklistToEdit = checklist
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - UINavigationControllerDelegate
    // When user taps back button this gets called before viewDidAppear
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // If the back button was tapped, the new vc is AllListsVC
        // Notes: == -> two variables have same value, === -> Same object
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }

    // MARK: - ListDetailTableViewControllerDelegate
    func listDetailTableViewControllerDidCancel(_ controller: ListDetailTableViewController) {
        navigationController?.popViewController(animated: true)
    }

    func listDetailTableViewController(_ controller: ListDetailTableViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        // Don't need to add rows manually because of the tableview.reloadData(), in an app with many rows this would not scale.
        // let indexPath = IndexPath(row: dataModel.lists.count - 1, section: 0)
        // tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }

    func listDetailTableViewController(_ controller: ListDetailTableViewController, didFinishEditing checklist: Checklist) {
        // Don't need to add rows manually because of the tableview.reloadData(), in an app with many rows this would not scale.
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}
