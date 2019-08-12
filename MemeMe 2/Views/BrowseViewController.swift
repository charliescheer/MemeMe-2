//
//  BrowseViewController.swift
//  MemeMe 2
//
//  Created by Charlie Scheer on 8/11/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class BrowseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
    }
    
    @objc func addMeme() {
        let vc = MemeEditViewController.loadViewController()
        
        present(vc, animated: true, completion: nil)
    }
}
