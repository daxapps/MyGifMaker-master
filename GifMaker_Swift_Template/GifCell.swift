//
//  GifCell.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/23/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

class GifCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    func configureForGif(_ gif: Gif) {
        gifImageView.image = gif.gifImage
    }
}
