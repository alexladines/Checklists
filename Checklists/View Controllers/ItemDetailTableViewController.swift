//
//  ItemDetailTableViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit
import UserNotifications

// Inherit from class because any references to this delegate are weak.
// For weak references we need a protocol which can only be used with a reference type.
protocol ItemDetailTableViewControllerDelegate: class {
    func itemDetailTableViewControllerDidCancel(_ controller: ItemDetailTableViewController)
    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishAdding item: ChecklistItem)
    func itemDetailTableViewController(_ controller: ItemDetailTableViewController, didFinishEditing item: ChecklistItem)
}

class ItemDetailTableViewController: UITableViewController, UITextFieldDelegate {
    // MARK: - Properties
    
    // Delegates are weak to describe their relationship with the vc.
    // weak = are allowed to become nil again, unowned = can't do this.
    weak var delegate: ItemDetailTableViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    var dueDate = Date()
    var datePickerVisible = false

    // MARK: - IBOutlets
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!

    // MARK: - IBActions
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.itemDetailTableViewControllerDidCancel(self)
    }

    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        // If itemToEdit is not nil then it means user is editing.
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            itemToEdit.shouldRemind = shouldRemindSwitch.isOn
            itemToEdit.dueDate = dueDate
            itemToEdit.scheduleNotification()
            delegate?.itemDetailTableViewController(self, didFinishEditing: itemToEdit)
        }
        else {
            let item = ChecklistItem(text: textField.text!)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailTableViewController(self, didFinishAdding: item)
        }
    }

    

    // TextField - Did End On Exit
    @IBAction func keyboardDoneButtonTapped() {
        // If itemToEdit is not nil then it means user is editing.
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            itemToEdit.shouldRemind = shouldRemindSwitch.isOn
            itemToEdit.dueDate = dueDate
            itemToEdit.scheduleNotification()
            delegate?.itemDetailTableViewController(self, didFinishEditing: itemToEdit)
        }
        else {
            let item = ChecklistItem(text: textField.text!)
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailTableViewController(self, didFinishAdding: item)
        }
    }

    // Picker - Value Changed
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        dueDate = sender.date
        updateDueDateLabel()
    }

    // UISwitch - Ask for permission for notifications
    @IBAction func shouldRemindToggled(_ sender: UISwitch) {
        textField.resignFirstResponder()

        if sender.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                // Do nothing
            }
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
        textField.delegate = self

        // If itemToEdit = nil then user hit the add button.
        if let itemToEdit = itemToEdit {
            title = "Edit Item"
            textField.text = itemToEdit.text
            // Done button on Navigation Bar is initially disabled.
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = itemToEdit.shouldRemind
            dueDate = itemToEdit.dueDate
        }

        updateDueDateLabel()
    }

    // MARK: - Methods
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }

    func showDatePicker() {
        datePickerVisible = true

        let indexPathDatePicker = IndexPath(row: 2, section: 1)
        tableView.insertRows(at: [indexPathDatePicker], with: .fade)
        datePicker.setDate(dueDate, animated: false)
        dueDateLabel.textColor = dueDateLabel.tintColor
    }

    func hideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            dueDateLabel.textColor = .black
        }
    }

    // MARK: - Navigation

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        }
        else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 2 {
            return datePickerCell
        }
        else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }

    // MARK: - UITableViewDelegate

    //Prevent cell from going gray from selection
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            return indexPath
        }
        else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()

        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            }
            else {
                hideDatePicker()
            }
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        }
        else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    // App crashes without this due to overridng data source for a static table view cell
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        var newIndexPath = indexPath
        if indexPath.section == 1 && indexPath.row == 2 {
            newIndexPath = IndexPath(row: 0, section: indexPath.section)
        }
        return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
    }

    // MARK: - UITextFieldDelegate

    // Disable Done Bar Button when there is no text.
    // Even with this, the done button is initially enabled when the vc comes to life. Don't forget to disable it!
    // Can fix this in storyboard - uncheck the enabled box.
    // Second Issue - If enabling the clear button on the keyboard.
    // If user hits the clear button the done button will not get disabled. This happens because the clear button calls a different delegate method, see below.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)

        if newText.isEmpty {
            doneBarButton.isEnabled = false
        }
        else {
            doneBarButton.isEnabled = true
        }

        return true

    }

    // Read above for the problem this fixes.
    // Clear button is the little x on the right of the text field.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

    // Hide the picker when user hits the text field.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }

}
