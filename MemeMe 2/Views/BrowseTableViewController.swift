//
//  BrowseTableViewController.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/11/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import CoreData

class BrowseTableViewController: BrowseViewController {
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.rowHeight = 200
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table.reloadData()
    }
}

extension BrowseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let fetchedResultsArray = resultsController.fetchedObjects else {
            return 0
        }
        
        return fetchedResultsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let browseTableCell = tableView.dequeueReusableCell(withIdentifier: constants.browseCellIdentifier, for: indexPath) as? BrowseTableViewCell else {
            print("failed")
            return UITableViewCell()
            
        }
        
        //Decode the data saved in the Memes NSManagedObject to get the meme object
        //Present the decoded meme in the tableView
        guard let memeData = resultsController.object(at: indexPath) as? Memes else {
            return browseTableCell
        }
        
        guard let decodedMeme = Meme.getMemeFromArchivedMemesData(memeData) else {
            return browseTableCell
        }

        browseTableCell.memeImageView.image = decodedMeme.meme
        browseTableCell.topTextLabel.text = decodedMeme.topText
        browseTableCell.bottomTextLabel.text = decodedMeme.bottomText
        
        return browseTableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let memeData = resultsController.object(at: indexPath) as? Memes else {
            return
        }
    
        let destination = instantiateMemeEditViewControllerWith(memeData)
        
        present(destination, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
           MemoryFunctions.deleteSelectedMemeAt(indexPath)
            
            tableReloadData()
            
        }
    }
    
    func tableReloadData() {
        
        do {
            try resultsController.performFetch()
            table.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }

}

extension BrowseTableViewController {
    enum constants {
        static let browseCellIdentifier = "BrowseCell"
        static let createMemeName = "CreateMeme"
    }
}
