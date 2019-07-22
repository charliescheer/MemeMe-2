//
//  ViewController.swift
//  MemeMe
//
//  Created by Charlie Scheer on 7/22/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        enableTextEditingAndSharing(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    func setupView() {
        if imageView.image != nil {
            enableTextEditingAndSharing(true)
        }
    }
    
    func enableTextEditingAndSharing(_ bool : Bool) {
        if bool {
            shareButton.isEnabled = true
            topTextField.isEnabled = true
            bottomTextField.isEnabled = true
        } else {
            shareButton.isEnabled = false
            topTextField.isEnabled = false
            bottomTextField.isEnabled = false
        }
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
    }
    
}

