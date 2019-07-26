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
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -2,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
        
        
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
    }
    
    func setupTextFields(_ textField: UITextField, _ tag : Int) {
        
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
        print("keyboard shows")
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        print("inside get keyboard height")
        return keyboardSize.cgRectValue.height
        
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        print("subscribed")
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func allowTextEditingAndSharing(_ bool : Bool) {
        shareButton.isEnabled = bool
        topTextField.isEnabled = bool
        bottomTextField.isEnabled = bool

    }
    
    
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
            print("Couldn't get image")
            //ADD AN ALERT TO DISPLAY TO THE USER
            return
        }
        
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension MemeEditViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        print("image selected")
        if let image = info[.originalImage] as? UIImage {
            print("receive image")
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

