//
//  ViewController.swift
//  MemeMe
//
//  Created by Iulia Nitulescu on 28/03/2018.
//  Copyright © 2018 Iulia Nitulescu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    struct Meme {
        let topText: String
        let bottomText: String
        let originalImage: UIImage
        let memedImage: UIImage
    }

    let memeTextAttributes:[String: Any] = [
        NSAttributedStringKey.strokeColor.rawValue: UIColor.black,
        NSAttributedStringKey.foregroundColor.rawValue: UIColor.white,
        NSAttributedStringKey.font.rawValue: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedStringKey.strokeWidth.rawValue: -5.0]
    let memeTextFieldDelegate = MemeTextFieldDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure top and bottom text fields
        configure(textField: topTextField)
        configure(textField: bottomTextField)

        // Disable the camera button if source is not available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        setDefaultValues()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        // Move view upwards when showing keyboard for bottom text field
        if bottomTextField.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }

    @objc func keyboardWillHide(_ notification:Notification) {
        // Move view back when hiding the keyboard
        view.frame.origin.y = 0
    }

    @IBAction func pickImageFromAlbum(_ sender: Any) {
        pickImage(.photoLibrary)
    }

    @IBAction func pickImageFromCamera(_ sender: Any) {
        pickImage(.camera)
    }

    func pickImage(_ sourceType: UIImagePickerControllerSourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            shareButton.isEnabled = true
        }

        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func shareMemedImage(_ sender: Any) {
        // Show Activity View
        let image = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        controller.completionWithItemsHandler = { activity, success, items, error in
            if success {
                self.save(image)
            }
        }
        self.present(controller, animated: true, completion: nil)
    }

    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        configureBars(hidden: true)

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        configureBars(hidden: false)
        
        return memedImage
    }

    func save(_ memedImage: UIImage) {
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
    }

    @IBAction func cancel(_ sender: Any) {
        setDefaultValues()
    }

    func setDefaultValues() {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageView.image = nil

        // Share button should be disabled until a picture is selected
        shareButton.isEnabled = false
    }
    
    func configure(textField: UITextField){
        // Configure meme text field: set delegate, default attributes
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.delegate = memeTextFieldDelegate
    }
    
    func configureBars(hidden: Bool) {
        toolbar.isHidden = hidden
        navbar.isHidden = hidden
    }
}
