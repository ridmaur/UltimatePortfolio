//
//  DataController.swift
//  UltimatePortfolio
//
//  Created by Rob In der Maur on 25/10/2020.
//

import CoreData
import SwiftUI

// this class is responsible for loading and managing data using Core Data
// but also synchronising it with iCloud
// so we can create an instance and watch it if needed
class DataController: ObservableObject {
    let container: NSPersistentCloudKitContainer
    
    // will load the actual underlying database on disk,
    // or create it if it doesn’t already exist,
    // but if that fails somehow we don’t really have any choice
    // but to bail out – something is very seriously wrong!
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Main")

        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
    
    // will create a bunch of projects and items.
    // This is only useful for testing and previewing, but it really does come in handy.
    func createSampleData() throws {
        let viewContext = container.viewContext

        for i in 1...5 {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.items = []
            project.creationDate = Date()
            project.closed = Bool.random()

            for j in 1...10 {
                let item = Item(context: viewContext)
                item.title = "Item \(j)"
                item.creationDate = Date()
                item.completed = false
                item.project = project
                item.priority = Int16.random(in: 1...3)

                item.completed = Bool.random()
            }
        }

        try viewContext.save()
    }
    
    // save changes, so that if some other part of our app has made changes to our data
    // it can write those out to disk
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }

    // to delete one specific project or item from our view context
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }

    // zap the contents of our database instantly
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Item.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)

        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
    }
    
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "items":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        case "complete":
            let fetchRequest: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value

        default:
            // fatalError("Unknown award criterion \(award.criterion).")
            return false;
        }
    }
    
    //if you prefer using previews you’ll find this really useful because it creates a data
    // controller in memory and adds some sample data, all in one
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext

        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error creating preview: \(error.localizedDescription)")
        }

        return dataController
    }()
}




