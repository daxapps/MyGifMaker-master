//
//  WelcomeViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/21/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
        
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let proofOfConceptGif = UIImage.gif(name: "hotlineBling")
        gifImageView.image = proofOfConceptGif
        UserDefaults.standard.set(true, forKey: "WelcomeViewSeen")
        
        navigationController?.viewControllers[0].title = ""
    }




}
