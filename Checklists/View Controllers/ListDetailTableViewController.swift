//
//  ListDetailTableViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/26/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

protocol ListDetailTableViewControllerDelegate: class {
    func listDetailTableViewControllerDidCancel(_ controller: ListDetailTableViewController)
    func listDetailTableViewController(_ controller: ListDetailTableViewController, didFinishAdding checklist: Checklist)
    func listDetailTableViewController(_ controller: ListDetailTableViewController, didFinishEditing checklist: Checklist)
}

class ListDetailTableViewController: UITableViewController, UITextFieldDelegate, IconPickerTableViewControllerDelegate {
    // MARK: - Properties
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImage: UIImageView!

    weak var delegate: ListDetailTableViewControllerDelegate?
    var iconName = "Folder"

    var checklistToEdit: Checklist?

    // MARK: - IBOutlets

    // MARK: - IBActions
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.listDetailTableViewControllerDidCancel(self)
    }

    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        // User was editing
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.name = textField.text!
            checklistToEdit.iconName = iconName
            delegate?.listDetailTableViewController(self, didFinishEditing: checklistToEdit)
        }

        // User was adding an item
        else {
            let checklist = Checklist(name: textField.text!)
            checklist.iconName = iconName
            delegate?.listDetailTableViewController(self, didFinishAdding: checklist)
        }
    }

    @IBAction func keyboardDoneButtonTapped() {
        // User was editing
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.name = textField.text!
            checklistToEdit.iconName = iconName
            delegate?.listDetailTableViewController(self, didFinishEditing: checklistToEdit)
        }

            // User was adding an item
        else {
            let checklist = Checklist(name: textField.text!)
            checklist.iconName = iconName
            delegate?.listDetailTableViewController(self, didFinishAdding: checklist)
        }
    }

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never

        if let checklistToEdit = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklistToEdit.name
            doneBarButton.isEnabled = true
            iconName = checklistToEdit.iconName
        }
        else {
            title = "Add Checklist"
        }

        iconImage.image = UIImage(named: iconName)
        textField.delegate = self
    }

    // MARK: - Methods

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destination as! IconPickerTableViewController
            controller.delegate = self
        }
    }

    // MARK: - Data Persistance

    // MARK: - UITableViewDataSource

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }

    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    // IconPickerTableViewControllerDelegate
    func iconPickerTableViewController(_ picker: IconPickerTableViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
}
