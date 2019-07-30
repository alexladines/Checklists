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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel!.text = dataModel.lists[indexPath.row].name
        cell.textLabel?.font = UIFont.systemFont(ofSize: 21)
        cell.accessoryType = .detailDisclosureButton
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
        let indexPath = IndexPath(row: dataModel.lists.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }

    func listDetailTableViewController(_ controller: ListDetailTableViewController, didFinishEditing checklist: Checklist) {
        // ChecklistItem has to conform to Equatable, we can conform to NSObject to fix this.
        if let index = dataModel.lists.firstIndex(of: checklist) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel?.text = checklist.name
            }
        }

        navigationController?.popViewController(animated: true)
    }
    
}
