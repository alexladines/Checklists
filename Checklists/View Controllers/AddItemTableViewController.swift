//
//  AddItemTableViewController.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import UIKit

// Inherit from class because any references to this delegate are weak.
// For weak references we need a protocol which can only be used with a reference type.
protocol AddItemTableViewControllerDelegate: class {
    func addItemTableViewControllerDidCancel(_ controller: AddItemTableViewController)
    func addItemTableViewController(_ controller: AddItemTableViewController, didFinishAdding item: ChecklistItem)
}

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {

    // MARK: - Properties
    // Delegates are weak to describe their relationship with the vc.
    // weak = are allowed to become nil again, unowned = can't do this.
    weak var delegate: AddItemTableViewControllerDelegate?

    // MARK: - IBOutlets
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var addItemTextField: UITextField!


    // MARK: - IBActions
    @IBAction func cancelBarButtonTapped(_ sender: UIBarButtonItem) {
        delegate?.addItemTableViewControllerDidCancel(self)
    }

    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let item = ChecklistItem(text: addItemTextField.text!)
        delegate?.addItemTableViewController(self, didFinishAdding: item)
    }

    // TextField - Did End On Exit
    @IBAction func keyboardDoneButtonTapped() {
        let item = ChecklistItem(text: addItemTextField.text!)
        delegate?.addItemTableViewController(self, didFinishAdding: item)
    }

    // MARK: - Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addItemTextField.becomeFirstResponder()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        addItemTextField.delegate = self
        
    }

    // MARK: - Methods

    // MARK: - Navigation

    // MARK: - UITableViewDataSource

    // MARK: - UITableViewDelegate

    //Prevent cell from going gray from selection
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
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

}
