//
//  NotificationManager.swift
//  RemindersApp
//
//  Created on $(DATE).
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Permission
    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    // MARK: - Reminder Notifications
    func scheduleReminderNotification(for reminder: Reminder) {
        guard let dueDate = reminder.dueDate, dueDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = reminder.title
        content.sound = .default
        content.badge = 1
        
        if let notes = reminder.notes, !notes.isEmpty {
            content.body += "\n\(notes)"
        }
        
        // Set category based on priority
        switch reminder.priorityEnum {
        case .high:
            content.categoryIdentifier = "HIGH_PRIORITY_REMINDER"
        case .medium:
            content.categoryIdentifier = "MEDIUM_PRIORITY_REMINDER"
        case .low:
            content.categoryIdentifier = "LOW_PRIORITY_REMINDER"
        }
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: reminder.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
    
    func cancelReminderNotification(for reminder: Reminder) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [reminder.id.uuidString])
    }
    
    // MARK: - Event Notifications
    func scheduleEventNotification(for event: CalendarEvent, minutesBefore: Int = 15) {
        guard event.startDate > Date() else { return }
        
        let notificationDate = Calendar.current.date(byAdding: .minute, value: -minutesBefore, to: event.startDate)
        guard let notificationDate = notificationDate, notificationDate > Date() else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Upcoming Event"
        content.body = event.title
        content.sound = .default
        content.badge = 1
        
        if let location = event.location, !location.isEmpty {
            content.body += " at \(location)"
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        content.body += " starts at \(formatter.string(from: event.startDate))"
        
        content.categoryIdentifier = "EVENT_REMINDER"
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: notificationDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        let request = UNNotificationRequest(identifier: event.id.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling event notification: \(error)")
            }
        }
    }
    
    func cancelEventNotification(for event: CalendarEvent) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [event.id.uuidString])
    }
    
    // MARK: - Notification Categories
    func setupNotificationCategories() {
        let completeAction = UNNotificationAction(identifier: "COMPLETE_ACTION",
                                                 title: "Mark Complete",
                                                 options: [.foreground])
        
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                               title: "Snooze 15 min",
                                               options: [])
        
        // Reminder categories
        let highPriorityCategory = UNNotificationCategory(identifier: "HIGH_PRIORITY_REMINDER",
                                                          actions: [completeAction, snoozeAction],
                                                          intentIdentifiers: [],
                                                          options: [])
        
        let mediumPriorityCategory = UNNotificationCategory(identifier: "MEDIUM_PRIORITY_REMINDER",
                                                           actions: [completeAction, snoozeAction],
                                                           intentIdentifiers: [],
                                                           options: [])
        
        let lowPriorityCategory = UNNotificationCategory(identifier: "LOW_PRIORITY_REMINDER",
                                                        actions: [completeAction],
                                                        intentIdentifiers: [],
                                                        options: [])
        
        // Event category
        let eventCategory = UNNotificationCategory(identifier: "EVENT_REMINDER",
                                                  actions: [],
                                                  intentIdentifiers: [],
                                                  options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([highPriorityCategory, mediumPriorityCategory, lowPriorityCategory, eventCategory])
    }
}
