//
//  ViewController.swift
//  MemeMe
//
//  Created by Charlie Scheer on 7/22/19.
//  Copyright © 2019 Praxsis. All rights reserved.
//

import UIKit
import CoreData

class MemeEditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate  {
    
    //MARK: Properties
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    let memeTextFieldDelegate = MemeTextFieldDelegate()
    var memeData: Memes? = nil
    
    //MARK: View loading/disappearing functions
    override func viewDidLoad() {
        super.viewDidLoad()
        allowTextEditingAndSharing(false)
        setupView()
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            cameraButton.isEnabled = false
        }
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 6.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotifications()
        
        if let data = memeData {
            if let unarchivedMeme = Meme.getMemeFromArchivedMemesData(data) {
                imageView.image = unarchivedMeme.image
                topTextField.text = unarchivedMeme.topText
                bottomTextField.text = unarchivedMeme.bottomText
            }
            
        }
        
        if imageView.image != nil {
            allowTextEditingAndSharing(true)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func setupView() {
        //if an image has been selected enable the text fields and sharing button
        if imageView.image != nil {
            allowTextEditingAndSharing(true)
        }
        
        view.backgroundColor = .lightGray
        
        //set text field properties and delegates
        configureTextField(topTextField, text: "TOP")
        configureTextField(bottomTextField, text: "BOTTOM")
    }
    
    //Boolean toggle to enable text fields and the sharing button
    func allowTextEditingAndSharing(_ bool : Bool) {
        shareButton.isEnabled = bool
        topTextField.isEnabled = bool
        bottomTextField.isEnabled = bool
        
    }
    
    func configureTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.textAlignment = .center
        textField.delegate = memeTextFieldDelegate
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        textField.defaultTextAttributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: constants.fontStyle, size: 40)!,
            NSAttributedString.Key.strokeWidth: -2,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
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
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
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
        //generate meme
        let meme = generateMemedImage()
        
        //Set activity view controller and present it
        let activityViewController = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        
        activityViewController.completionWithItemsHandler = { ( acitivityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
    
            if completed == true {
                self.save()
                self.dismiss(animated: true, completion: nil)
            } else {
                print("service was canceled")
                self.dismiss(animated: true, completion: nil)
            }
            
            if error != nil {
                print("there was an error of type \(error!.localizedDescription)")
            }
            
        }
        present(activityViewController, animated: true, completion: nil)

    }
    
    @IBAction func cancelWasTapped(_ sender: Any) {
            self.dismiss(animated: true, completion: nil)
    }
    
    //Creates Meme object and sets it's properties
    //Save meme to coreData
    func save () {
        let context = MemoryFunctions.getManagedObjectContext()
        
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: saveCroppedImage(), meme: generateMemedImage())
        let memeData = meme.getMemeAsData()
        
        if let memeToBeSaved = NSEntityDescription.insertNewObject(forEntityName: data.entityName, into: context) as? Memes {
            memeToBeSaved.uuid = UUID()
            memeToBeSaved.meme = memeData
            memeToBeSaved.creationDate = Date()
        }
        
        MemoryFunctions.saveContext(context: context)
        
    }
        
    
    //Generate the meme by combining the image and the text fields
    func generateMemedImage() -> UIImage {
        //hide the toolbars
        hideToolbars(true)
        
        //capture the screen
        let memedImage = createImageFromCurrentScreen()
        
        //restore the toolbars
        hideToolbars(false)
        
        return memedImage
    }
    
    func saveCroppedImage() -> UIImage {
        hideToolbars(true)
        hideTextFields(true)
        
        let croppedImage = createImageFromCurrentScreen()
        
        hideTextFields(false)
        hideToolbars(false)
        return croppedImage
        
    }
    
    func createImageFromCurrentScreen() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func hideTextFields(_ bool: Bool) {
        self.topTextField.isHidden = bool
        self.bottomTextField.isHidden = bool
    }
    
    //Boolean toggle to hide or show the toolsbars on the screen
    func hideToolbars(_ bool: Bool) {
        self.topToolBar.isHidden = bool
        self.bottomToolBar.isHidden = bool
    }
    
    //Create and display a UI image picker controller for camera or photo library
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
    
    
    //MARK: Image picker methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //Generic UIAlert function
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
    
    enum data {
        static let entityName = "Memes"
    }
}

