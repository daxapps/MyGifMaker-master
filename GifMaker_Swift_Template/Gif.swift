//
//  Gif.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/22/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit

class Gif: NSObject, NSCoding {
    
    let url: URL
    let videoURL: URL?
    let caption: String?
    let gifImage: UIImage?
    var gifData: NSData?
    
    init(url: URL, caption: String, gifImage: UIImage, videoURL: URL) {
        
        self.url = url
        self.videoURL = videoURL
        self.caption = caption
        self.gifImage = gifImage
        self.gifData = nil
    }
    
    required init?(coder decoder: NSCoder) {
        self.url = (decoder.decodeObject(forKey: "url") as? URL)!
        self.videoURL = decoder.decodeObject(forKey: "videoURL") as? URL
        self.caption = decoder.decodeObject(forKey: "caption") as? String
        self.gifImage = decoder.decodeObject(forKey: "gifImage") as? UIImage
        self.gifData = decoder.decodeObject(forKey: "gifData") as? NSData
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(self.url, forKey: "url")
        coder.encode(self.videoURL, forKey: "videoURL")
        coder.encode(self.caption, forKey: "caption")
        coder.encode(self.gifImage, forKey: "gifImage")
        coder.encode(self.gifData, forKey:"gifData")
    }
//    init(name: String) {
//        self.gifImage = UIImage.gif(name: name)
//    }
}



