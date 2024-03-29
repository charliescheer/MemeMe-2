//
//  BrowseViewController.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/11/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import CoreData

class BrowseViewController: UIViewController {
    let resultsController = MemoryFunctions.resultsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create add barbutton item
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //Fetch memes from CoreData
        do {
            try resultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //present the MemeEditViewController
    @objc func addMeme() {
        let storyboard = UIStoryboard(name: "CreateMeme", bundle: Bundle.main)
        guard let vc = storyboard.instantiateInitialViewController() else {
            return
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    //Load a MemeEditViewController with a savedMemesObject for editing
    func instantiateMemeEditViewControllerWith(_ savedMemesObject: Memes) -> MemeEditViewController {
        let storyboard = UIStoryboard(name: "CreateMeme", bundle: nil)
        let vc = storyboard.instantiateInitialViewController() as! MemeEditViewController
        
        vc.managedMemesObjectFromStorage = savedMemesObject
        
        return vc
    }
}
