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
    var memesArray = [Meme]()
    let resultsController = MemoryFunctions.resultsController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @objc func addMeme() {
        let storyboard = UIStoryboard(name: "CreateMeme", bundle: Bundle.main)
        guard let vc = storyboard.instantiateInitialViewController() else {
            return
        }
        
        present(vc, animated: true, completion: nil)
    }
}
