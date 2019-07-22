//
//  ViewController.swift
//  MemeMe
//
//  Created by Charlie Scheer on 7/22/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allowTextEditingAndSharing(false)
        topTextField.delegate = memeTextFieldDelegate
        bottomTextField.delegate = memeTextFieldDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    func setupView() {
        if imageView.image != nil {
            allowTextEditingAndSharing(true)
        }
    }
    
    func allowTextEditingAndSharing(_ bool : Bool) {
        shareButton.isEnabled = bool
        topTextField.isEnabled = bool
        bottomTextField.isEnabled = bool

    }
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
    }
    
    @IBAction func albumButtonTapped(_ sender: Any) {
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
    }
    
}

