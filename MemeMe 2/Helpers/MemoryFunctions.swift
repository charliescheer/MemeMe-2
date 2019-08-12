//
//  MemoryFunctions.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/12/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

enum MemoryFunctions {
    static func archiveMemesArray(_ memesArray: [Meme]) -> Data {
        var data = Data()
        
        do {
            let archivedData = try NSKeyedArchiver.archivedData(withRootObject: memesArray, requiringSecureCoding: false)
            data = archivedData
        } catch {
            print(error.localizedDescription)
        }
        
        return data
    }
    
    static func unarchiveMemeArray(_ memesData: Data) -> [Meme] {
        var memesArray: [Meme] = []
        
        do {
            let array = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(memesData) as? [Meme]
            
            if let unarchivedArray = array {
                memesArray = unarchivedArray
            }
            
        } catch {
            print(error.localizedDescription)
        }
        
        return memesArray
    }
    
    static func saveMemeArrayToStorage(_ memeArray: [Meme]) {
        let memeData = archiveMemesArray(memeArray)
        
        UserDefaults.standard.set(memeData, forKey: defaults.savedMemes)
    }
    
    static func getMemesArrayFromStorage() -> [Meme] {
        guard let memeData = UserDefaults.standard.data(forKey: defaults.savedMemes) else {
            print("No Data Found")
            return [Meme]()
        }
        
        let unarchivedMemesArray = unarchiveMemeArray(memeData)
        
        return unarchivedMemesArray
    }
}

extension MemoryFunctions {
    enum defaults {
        static let savedMemes = "savedMemes"
    }
}
