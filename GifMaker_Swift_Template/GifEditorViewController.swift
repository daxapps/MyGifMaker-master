//
//  GifEditorViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/21/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifEditorViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    
    var gif: Gif!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        print("viewWillAppear")
        captionTextField.delegate = self
        gifImageView.image = gif?.gifImage
        
        print(navigationItem.rightBarButtonItem as Any)
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(GifEditorViewController.presentPreview)
        
        let color = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = color
        let attributes: [String: AnyObject] = [NSForegroundColorAttributeName:color, NSFontAttributeName:captionTextField.font!, NSStrokeColorAttributeName : UIColor.black, NSStrokeWidthAttributeName : -4 as AnyObject]
        captionTextField.defaultTextAttributes = attributes
        captionTextField.textAlignment = .center
        
        title = "Add Caption"
        navigationController?.viewControllers[0].title = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeFromKeyboardNotifications()
        self.title = ""
    }
    
    // MARK: Tap gesture
    
    // Tap gesture that dismisses the keyboard
    func addTapToDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: textField delegate methods
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Observe and respond to keyboard notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)),name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        view.frame.origin.y = -getKeyboardHeight(notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // MARK: Preview gif
    
    @IBAction func presentPreview() {
        captionTextField.text = gif.caption
        let regift = Regift(sourceFileURL: gif.videoURL!, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        
        let captionFont = captionTextField.font!
        let gifURL = regift.createGif(caption: captionTextField.text!, font: captionFont)
        print(gifURL as Any)
        let newGif = Gif(url: gifURL!, caption: captionTextField.text!, gifImage: UIImage.gif(url: String(describing: gifURL!))!, videoURL: gifURL!)
        
        performSegue(withIdentifier: "ShowPreview", sender: newGif)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowPreview" {
            let destinationVC = segue.destination as! PreviewViewController
            destinationVC.gif = sender as! Gif
        }
    }

}








