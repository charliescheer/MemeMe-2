//
//  BrowseCollectionViewController.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/11/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class BrowseCollectionViewController: BrowseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
}

extension BrowseCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchedResultsArray = resultsController.fetchedObjects else {
            return 0
        }
        return fetchedResultsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: constants.collectionViewCellIdentifier, for: indexPath) as? BrowseCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let memeData = resultsController.object(at: indexPath) as? Memes {
            do {
                let decoder = PropertyListDecoder()
                let meme = try decoder.decode(Meme.self, from: memeData.meme!)
                cell.browseImageView.image = meme.meme
            } catch {
                print(error.localizedDescription)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width/3, height: self.view.frame.width/3)
    }
}

extension BrowseCollectionViewController {
    enum constants {
        static let collectionViewCellIdentifier = "CollectionCell"
    }
}
