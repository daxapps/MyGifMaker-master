//
//  PreviewViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/21/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

//protocol PreviewViewControllerDelegate {
//    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif)
//}

class PreviewViewController: UIViewController {

    var gif:Gif!
    //var delegate: PreviewViewControllerDelegate! = nil
    
    @IBOutlet weak var gifImagePreview: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifImagePreview.image = gif.gifImage
        
        shareButton.layer.cornerRadius = 4.0
        shareButton.layer.borderColor = UIColor(red: 1, green: 65/255, blue: 112/255, alpha: 1).cgColor
        shareButton.layer.borderWidth = 1.0
        saveButton.layer.cornerRadius = 4.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        if let img = gif?.gifImage {
        //            gifImagePreview.image = img
        //        }
        //        title = "Preview"
        //self.applyTheme(theme: .Dark)
        navigationController?.viewControllers[1].title = ""
    }
    
    
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        self.title = ""
    //    }
    
    // MARK: Share Gif
    
    @IBAction func shareGif(_ sender: AnyObject) {
        //        let url: NSURL = (self.gif?.url)!
        //        let animatedGIF = NSData(contentsOf: url as URL)!
        //        let itemsToShare = [animatedGIF]
        //
        //        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        //
        //        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
        //            if completed {
        //                //self.navigationController?.popToRootViewController(animated: true)
        //            }
        //        }
        //
        //        navigationController?.present(activityVC, animated: true, completion: nil)
        let animatedGif = try! Data(contentsOf: gif.url )
        let itemsToShare = [animatedGif]
        let shareController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        shareController.completionWithItemsHandler = {activityType, completed, returnedItems, activityError in
            if completed {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        present(shareController, animated: true, completion: nil)
    }
    
    @IBAction func createAndSave() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.savedGifs.append(gif!)
        //delegate?.previewVC(preview: self, didSaveGif: gif!)
        navigationController?.popToRootViewController(animated: true)
    }
}







