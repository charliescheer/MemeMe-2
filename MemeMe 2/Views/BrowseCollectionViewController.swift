//
//  BrowseCollectionViewController.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/11/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class BrowseCollectionViewController: BrowseViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let spacing: CGFloat = 16.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFlowLayoutProperties()
        
        //set long press recognizer for deleting memes from Collection view
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView.addGestureRecognizer(lpgr)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.reloadData()
    }
    
    //Handle the longpress action
    @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizer.State.ended {
            let point = gestureRecognizer.location(in: gestureRecognizer.view)
            
            //Alert the user to confirm before deleting the selected Meme
            let alertController = UIAlertController(title: "Delete", message: "Do you want to delete this Meme?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                let p = self.view.convert(point, to: self.collectionView)
                let indexPath = self.collectionView.indexPathForItem(at: p)
                
                if let index = indexPath {
                    MemoryFunctions.deleteSelectedMemeAt(index)
                }

                self.collectionReloadData()
                
            }
            
            //Allow user to cancel delete
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(deleteAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    func collectionReloadData() {
        
        do {
            try resultsController.performFetch()
            collectionView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //Set the sizing properties for the collection view
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
        guard let memeData = resultsController.object(at: indexPath) as? Memes else {
            return cell
        }
        
        guard let decodedMeme = Meme.getMemeFromArchivedMemesData(memeData) else {
            return cell
        }
        
        cell.browseImageView.image = decodedMeme.meme
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let memeData = resultsController.object(at: indexPath) as? Memes else {
            return
        }
        
        let destination = instantiateMemeEditViewControllerWith(memeData)
        
        present(destination, animated: true, completion: nil)
    }
    
    /*CollectionViewCell Spacing code found at https://medium.com/@NickBabo/equally-spaced-uicollectionview-cells-6e60ce8d457b
     Author:Nicholas Babo
     Article: Equally Spaced UICollectionView Cells
     Site: Medium*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 3
        let spacingBetweenItems: CGFloat = 16
        
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenItems)
        
        if let collection = self.collectionView {
            let width = (collection.bounds.width - totalSpacing) / numberOfItemsPerRow
            return CGSize(width: width, height: width * 1.5)
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
