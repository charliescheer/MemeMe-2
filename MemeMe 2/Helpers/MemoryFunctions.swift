//
//  MemoryFunctions.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/12/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import CoreData

enum MemoryFunctions {
    //MARK: CoreData functions and Properties
    
    //Create Persistent Container
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: data.persistentContainerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static func getManagedObjectContext() -> NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //Check if any changes have been made to a given content
    //If there are changes save the changes
    static func saveContext (context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //Managed results controller for the Memes entity
    static var resultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: data.entityName)
        var managedObjectContext = MemoryFunctions.getManagedObjectContext()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: data.sortDescriptor, ascending: false)]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                    managedObjectContext: managedObjectContext,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        
        do{
            try controller.performFetch()
        } catch let error as NSError {
            assertionFailure("Failed to performFetch. \(error)")
        }
        
        var entityCount = controller.sections!.count
        
        return controller
    }()
    
}

extension MemoryFunctions {
    enum data {
        static let persistentContainerName = "MemesDataModel"
        static let entityName = "Memes"
        static let sortDescriptor = "uuid"
    }
}
