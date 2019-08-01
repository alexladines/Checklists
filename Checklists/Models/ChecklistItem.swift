//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Alex Ladines on 7/24/19.
//  Copyright © 2019 Alex Ladines. All rights reserved.
//

import Foundation
import UserNotifications

// Need the NSObject to use index(of:) on arrays of this object.
// Codable combines Encodable and Decodable protocols.
class ChecklistItem : NSObject, Codable  {

    // MARK: - Properties
    var text = ""
    var checked = false
    var dueDate = Date()
    var shouldRemind = false
    var itemID = -1


    // MARK: - Methods
    init(text: String, checked: Bool = false) {
        self.text = text
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }

    // Notification should be deleted when item is deleted.
    deinit {
        removeNotification()
    }

    func toggleChecked() {
        checked.toggle()
    }

    // Still have to add permission
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            // Testing
            print("We should schedule a notification!")

            // 1. Item text into the notification message
            let content = UNMutableNotificationContent()
            content.title  = "Reminder:"
            content.body = text
            content.sound = .default

            // 2. Get the components
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)

            // 3. Show notification at specified date
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

            // 4. We should be able to find the notification later if we need to cancel it
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)

            // 5. Add it to the center
            let center = UNUserNotificationCenter.current()
            center.add(request)

            print("Scheduled: \(request) for itemID: \(itemID)")
        }
    }

    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }

    // MARK: - Codable

    // MARK: - Equatable

    // MARK: - Core Data

    // MARK: - UserDefaults

    // MARK: - Data Persistance
}
