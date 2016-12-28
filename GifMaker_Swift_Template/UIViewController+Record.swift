//
//  UIViewController+Record.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/21/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import AVFoundation

// Regift constants
let frameCount = 16
let frameRate = 15
let delayTime: Float = 0.2
let loopCount = 0  // 0 means loop forever


// MARK: - UIViewController (Record)

extension UIViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //MARK: Select Video
    
    @IBAction func presentVideoOptions() {
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
             launchPhotoLibrary()
        } else {
            let newGifActionSheet = UIAlertController(title: "Create new GIF", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
            let recordVideo = UIAlertAction(title: "Record a Video", style: UIAlertActionStyle.default, handler: {(UIAlertAction) in
                    self.launchVideoCamera()
                })
            let chooseFromExisting = UIAlertAction(title: "Choose from Existing", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                 self.launchPhotoLibrary()
                })
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            
            newGifActionSheet.addAction(recordVideo)
            newGifActionSheet.addAction(chooseFromExisting)
            newGifActionSheet.addAction(cancel)
            
            present(newGifActionSheet, animated: true, completion: nil)
            let pinkColor = UIColor(colorLiteralRed: 255.0/255.0, green: 65.0/255.0, blue: 112.0/255.0, alpha: 1.0)
            newGifActionSheet.view.tintColor = pinkColor
        }
    }
    
    func launchVideoCamera() {
        // Create imagePicker
        let recordVideoController = UIImagePickerController()
        recordVideoController.sourceType = UIImagePickerControllerSourceType.camera
        recordVideoController.mediaTypes = [kUTTypeMovie as String]
        recordVideoController.allowsEditing = false
        recordVideoController.delegate = self
        
        present(recordVideoController, animated: true, completion: nil)
    }
    
    func launchPhotoLibrary() {
        let pickerController = imagePicker(source: .photoLibrary)
        
        self.present(pickerController, animated: true, completion: nil)
    }
    //}

// MARK: - UIViewController: UINavigationControllerDelegate

//extension UIViewController: UINavigationControllerDelegate {}

// MARK: - UIViewController: UIImagePickerControllerDelegate

//extension UIViewController: UIImagePickerControllerDelegate {
    
    func imagePicker(source: UIImagePickerControllerSourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = source
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.delegate = self
        picker.allowsEditing = true
        
        return picker
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! String
        
        if mediaType == kUTTypeMovie as String {
            let videoURL = info[UIImagePickerControllerMediaURL] as! NSURL
            //UISaveVideoAtPathToSavedPhotosAlbum(videoURL.path!, nil, nil, nil)
            //dismiss(animated: true, completion: nil)
            
            let start = info["_UIImagePickerControllerVideoEditingStart"] as? NSNumber
            let end = info["_UIImagePickerControllerVideoEditingEnd"] as? NSNumber
            var duration: NSNumber?
            if let start = start {
                duration = NSNumber(value: end!.floatValue - start.floatValue)
            }
            else {
                duration = nil
            }
            //convertVideoToGif(videoURL: videoURL, start: start, duration: duration)
            cropVideoToSquare(rawVideoURL: videoURL, start: start, duration: duration)
        }
    }

    func cropVideoToSquare(rawVideoURL: NSURL, start: NSNumber?, duration: NSNumber?) {
        
        // Create the AVAsset and AVAssetTrack
        let videoAsset = AVAsset(url: rawVideoURL as URL)
        let videoTrack = videoAsset.tracks(withMediaType: AVMediaTypeVideo)[0]
        
        // Crop to square
        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = CGSize(width: videoTrack.naturalSize.height, height: videoTrack.naturalSize.height)
        videoComposition.frameDuration = CMTimeMake(1, 30)
        
        // Initialize instruction and set time range
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: kCMTimeZero, duration: CMTimeMakeWithSeconds(60, 30))
        
        // Center the cropped video
        let transformer = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTrack)
        let t1 = CGAffineTransform(translationX: videoTrack.naturalSize.height, y: -(videoTrack.naturalSize.width - videoTrack.naturalSize.height) / 2)
        
        //Rotate 90 degrees to portrait
        let finalTransform = t1.rotated(by: CGFloat(M_PI_2))
        transformer.setTransform(finalTransform, at: kCMTimeZero)
        //instruction.layerInstructions.append(transformer)
        instruction.layerInstructions = [transformer]
        //videoComposition.instructions.append(instruction)
        videoComposition.instructions = [instruction]
        
        // export the square video
        let exporter = AVAssetExportSession(asset: videoAsset, presetName: AVAssetExportPresetHighestQuality)
        exporter?.videoComposition = videoComposition
        let path = createPath()
        exporter?.outputURL = URL(fileURLWithPath: path)
        exporter?.outputFileType = AVFileTypeQuickTimeMovie
        
        var croppedURL:NSURL?
        exporter?.exportAsynchronously { () in
            croppedURL = exporter!.outputURL! as NSURL?
            self.convertVideoToGif(videoURL: croppedURL! as URL, start: start, duration: duration)
        }
    }
    
    func createPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let manager = FileManager.default
        
        var outputURL = documentsDirectory.appendingPathComponent("output") as NSString
        do {
            try manager.createDirectory(atPath: outputURL as String, withIntermediateDirectories: true, attributes: nil)
        } catch  {
            print(error)
        }
        outputURL = outputURL.appendingPathComponent("output.mov") as NSString
        
        // Remove Existing file
        do {
            try manager.removeItem(atPath: outputURL as String)
        } catch  {
            print(error)
        }
        
        return String(outputURL)
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // GIF conversion methods
    func convertVideoToGif(videoURL: URL, start: NSNumber?, duration: NSNumber?) {
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
        
        var regift: Regift
        
        if let start = start {
            // Trimmed
            regift = Regift(sourceFileURL: videoURL as URL, destinationFileURL: nil, startTime: Float(start), duration: Float(duration!), frameRate: frameRate, loopCount: loopCount)
        } else {
            // Untrimmed
            regift = Regift(sourceFileURL: videoURL as URL, destinationFileURL: nil, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
        }
        
        let gifURL = regift.createGif()
        let gifImage = UIImage.gif(url: String(describing: gifURL!))
        let gif = Gif(url: gifURL!, caption: "", gifImage: gifImage!, videoURL: videoURL)
        
        displayGif(gif: gif)
    }
    
    func  displayGif(gif: Gif) {
        let gifEditorVC = self.storyboard?.instantiateViewController(withIdentifier: "GifEditorViewController") as! GifEditorViewController
        gifEditorVC.gif = gif
        navigationController?.pushViewController(gifEditorVC, animated: true)
    }
    
    
}







