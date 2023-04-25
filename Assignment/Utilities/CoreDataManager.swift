//
//  CoreDataManager.swift
//  Assignment
//
//  Created by Vijay Arora on 21/01/23.
//  Copyright © 2023 Vijay Arora. All rights reserved.
//


import UIKit
import CoreData

protocol CoreDataManagerDelegate: AnyObject {
    func saveRecord(employees: [Employee])
    func getRecord(uuid: String?) -> Records?
    func saveBackgroundContext()
}

class CoreDataManager: NSObject, CoreDataManagerDelegate {
    
    static let shared = CoreDataManager()
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "Assignment")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    lazy var mainContext: NSManagedObjectContext = {
        let taskContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        taskContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return taskContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.parent = mainContext
        return privateMOC
    }()

    // MARK: - Core Data Saving support

    func saveRecord(employees: [Employee]) {
        backgroundContext.perform {
            employees.forEach { employee in
                if let record = self.getRecord(uuid: employee.uuid) {
                    record.fullName = employee.fullName
                    record.uuid = employee.uuid
                    record.biography = employee.biography
                    record.employeeType = employee.employeeType?.rawValue
                    record.photoURLSmall = employee.photoURLSmall
                    record.team = employee.team
                    record.phoneNumber = employee.phoneNumber
                } else {
                    let record = Records(context: self.backgroundContext)
                    record.fullName = employee.fullName
                    record.uuid = employee.uuid
                    record.biography = employee.biography
                    record.employeeType = employee.employeeType?.rawValue
                    record.photoURLSmall = employee.photoURLSmall
                    record.team = employee.team
                    record.phoneNumber = employee.phoneNumber
                }
            }
            self.saveBackgroundContext()
        }
    }
    
    func getRecord(uuid: String?) -> Records? {
        guard let uuid = uuid else { return nil }
        let fetchRequest = Records.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid = %@", uuid)
        let records = try? backgroundContext.fetch(fetchRequest)
        return records?.first
    }

    func saveBackgroundContext() {
        do {
            if backgroundContext.hasChanges {
               try backgroundContext.save()
            }
            saveMainContext()
        } catch {
            print(error)
        }
    }
    
    private func saveMainContext() {
        mainContext.performAndWait {
            do {
                try mainContext.save()
            } catch {
                print(error)
            }
        }
    }
}
