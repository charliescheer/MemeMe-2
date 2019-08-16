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
//    static func archiveMemesArray(_ memesArray: [Meme]) -> Data {
//        var data = Data()
//
//        do {
//            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: memesArray, requiringSecureCoding: false)
//            data = archivedData
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        return data
//    }
//
//    static func unarchiveMemeArray(_ memesData: Data) -> [Meme] {
//        var memesArray: [Meme] = []
//
//        do {
//            let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(memesData) as? [Meme]
//
//            if let unarchivedArray = array {
//                memesArray = unarchivedArray
//            }
//
//        } catch {
//            print(error.localizedDescription)
//        }
//
//        return memesArray
//    }
//
//    static func saveMemeArrayToStorage(_ memeArray: [Meme]) {
//        let memeData = archiveMemesArray(memeArray)
//
//        UserDefaults.standard.set(memeData, forKey: defaults.savedMemes)
//    }
//
//    static func getMemesArrayFromStorage() -> [Meme] {
//        guard let memeData = UserDefaults.standard.data(forKey: defaults.savedMemes) else {
//            print("No Data Found")
//            return [Meme]()
//        }
//
//        let unarchivedMemesArray = unarchiveMemeArray(memeData)
//
//        return unarchivedMemesArray
//    }
    
    //MARK: CoreData functions and Properties
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
    
    static var resultsController: NSFetchedResultsController = { () -> NSFetchedResultsController<NSFetchRequestResult> in
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: data.entityName)
        var managedObjectContext = MemoryFunctions.persistentContainer.viewContext
        
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
    enum defaults {
        static let savedMemes = "savedMemes"
    }
    
    enum data {
        static let persistentContainerName = "MemesDataModel"
        static let entityName = "Memes"
        static let sortDescriptor = "uuid"
    }
}
