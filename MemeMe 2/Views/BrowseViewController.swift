//
//  BrowseViewController.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/11/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    var memesArray = [Meme]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        memesArray = getMemesArray()
        
        print(memesArray.count)
    }
    
    @objc func addMeme() {
        let storyboard = UIStoryboard(name: "CreateMeme", bundle: Bundle.main)
        guard let vc = storyboard.instantiateInitialViewController() else {
            return
        }
        
        present(vc, animated: true, completion: nil)
    }
    
    //Gets an array of memes from the AppDelegate
    func getMemesArray() -> [Meme] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memesArray
    }
}
