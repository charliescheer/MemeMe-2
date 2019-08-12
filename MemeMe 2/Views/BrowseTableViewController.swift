//
//  BrowseTableViewController.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/11/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class BrowseTableViewController: BrowseViewController {
    @IBOutlet weak var table: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        table.rowHeight = 200
        table.reloadData()
    }
}

extension BrowseTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let browseTableCell = tableView.dequeueReusableCell(withIdentifier: constants.browseCellIdentifier, for: indexPath) as? BrowseTableViewCell else {
            print("failed")
            return UITableViewCell()
            
        }
        
        browseTableCell.memeImageView.image = memesArray[indexPath.row].meme
        browseTableCell.topTextLabel.text = memesArray[indexPath.row].topText
        browseTableCell.bottomTextLabel.text = memesArray[indexPath.row].bottomText
        
    
    return browseTableCell
    }
}

extension BrowseTableViewController {
    enum constants {
        static let browseCellIdentifier = "BrowseCell"
    }
}
