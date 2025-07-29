//
//  CoreDataManager.swift
//  RemindersApp
//
//  Created on $(DATE).
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RemindersApp")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving Support
    func saveContext() {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // MARK: - Reminder Operations
    func fetchReminders(predicate: NSPredicate? = nil) -> [Reminder] {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "dueDate", ascending: true),
                                  NSSortDescriptor(key: "priority", ascending: false)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching reminders: \(error)")
            return []
        }
    }
    
    func fetchOverdueReminders() -> [Reminder] {
        let predicate = NSPredicate(format: "dueDate < %@ AND isCompleted == %@", Date() as NSDate, NSNumber(value: false))
        return fetchReminders(predicate: predicate)
    }
    
    func fetchTodayReminders() -> [Reminder] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = NSPredicate(format: "dueDate >= %@ AND dueDate < %@ AND isCompleted == %@", 
                                   startOfDay as NSDate, endOfDay as NSDate, NSNumber(value: false))
        return fetchReminders(predicate: predicate)
    }
    
    // MARK: - Calendar Event Operations
    func fetchEvents(predicate: NSPredicate? = nil) -> [CalendarEvent] {
        let request: NSFetchRequest<CalendarEvent> = CalendarEvent.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching events: \(error)")
            return []
        }
    }
    
    func fetchEventsForDate(_ date: Date) -> [CalendarEvent] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = NSPredicate(format: "startDate >= %@ AND startDate < %@", 
                                   startOfDay as NSDate, endOfDay as NSDate)
        return fetchEvents(predicate: predicate)
    }
    
    func fetchUpcomingEvents(days: Int = 7) -> [CalendarEvent] {
        let endDate = Calendar.current.date(byAdding: .day, value: days, to: Date())!
        let predicate = NSPredicate(format: "startDate >= %@ AND startDate <= %@", 
                                   Date() as NSDate, endDate as NSDate)
        return fetchEvents(predicate: predicate)
    }
}
