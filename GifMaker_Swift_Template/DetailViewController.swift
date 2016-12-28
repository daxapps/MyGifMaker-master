//
//  DetailViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/24/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    var gif: Gif?
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gifImageView.image = gif?.gifImage
    }
    
    @IBAction func shareGif(_ sender: UIButton) {
        var itemsToShare = [NSData]()
        itemsToShare.append((self.gif?.gifData)!)
        
        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityVC.completionWithItemsHandler = {(activity, completed, items, error) in
            if (completed) {
                self.dismiss(animated: true, completion: nil)
            }
        }
        present(activityVC, animated: true, completion: nil)
    }
    @IBAction func closeButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

}
