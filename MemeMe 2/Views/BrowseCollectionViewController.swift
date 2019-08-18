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
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let spacing: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlowLayoutProperties()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    func setFlowLayoutProperties() {
        
        flowLayout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing

        
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
        
        //Decode the data saved in the Memes NSManagedObject to get the meme object
        //Present the decoded meme in the collectionView
        if let memeData = resultsController.object(at: indexPath) as? Memes {
            do {
                let decoder = PropertyListDecoder()
                let meme = try decoder.decode(Meme.self, from: memeData.meme!)
                cell.browseImageView.image = meme.meme
            } catch {
                print(error.localizedDescription)
            }
        }
        
        cell.backgroundColor = UIColor.blue
        
        return cell
    }

    
    /*CollectionViewCell Spacing code found at https://medium.com/@NickBabo/equally-spaced-uicollectionview-cells-6e60ce8d457b
    Author:Nicholas Babo
    Article: Equally Spaced UICollectionView Cells
    Site: Medium*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 5
        let spacingBetweenItems: CGFloat = 3
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenItems)
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerRow
            return CGSize(width: width, height: width)
        } else {
            return CGSize(width: 0.0, height: 0.0)
        }
        
    }
}

extension BrowseCollectionViewController {
    enum constants {
        static let collectionViewCellIdentifier = "CollectionCell"
    }
}
