//
//  ViewController.swift
//  MemeMe
//
//  Created by Charlie Scheer on 7/22/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    
    //MARK: View loading/disappearing functions
    override func viewDidLoad() {
        super.viewDidLoad()
        allowTextEditingAndSharing(false)
        topTextField.delegate = memeTextFieldDelegate
        bottomTextField.delegate = memeTextFieldDelegate
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            cameraButton.isEnabled = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupView() {
        if imageView.image != nil {
            allowTextEditingAndSharing(true)
        }
        
        view.backgroundColor = .lightGray
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        let memeTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: constants.fontStyle, size: 40)!,
            NSAttributedString.Key.strokeWidth: -2,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    func allowTextEditingAndSharing(_ bool : Bool) {
        shareButton.isEnabled = bool
        topTextField.isEnabled = bool
        bottomTextField.isEnabled = bool
        
    }
    
//
//    func setupTextFields(_ textField: UITextField, _ tag : Int) {
//
//    }
    
    //MARK: Keyboard will show notification methods
    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: Action functions
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        activateUIImagePicker(sender.tag)
    }
    
    @IBAction func albumButtonTapped(_ sender: UIBarButtonItem) {
        activateUIImagePicker(sender.tag)
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
    }
    
    
    func activateUIImagePicker(_ tag : Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        switch tag {
        case 1 :
                imagePicker.sourceType = .camera
        case 2 :
            imagePicker.sourceType = .photoLibrary
        default:
            displayErrorAlert(title: "Image Failed", message: "Could not access images at this time.  Please try again")
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func displayErrorAlert(title: String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        present(alert, animated: true)
    }
    
}

extension MemeEditViewController {
    enum constants {
        static let fontStyle = "HelveticaNeue-CondensedBlack"
    }

    
}

