//
//  SavedGifsViewController.swift
//  GifMaker_Swift_Template
//
//  Created by Jason Crawford on 12/23/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

import UIKit

//var gifsFilePath: String {
//    let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//    let directory = directories.first
//    let gifsPath = directory?.appending("/savedGifs")
//    return gifsPath!
//}

class SavedGifsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    let gifsURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/savedGifs"
    fileprivate var gifs = [Gif]()
    //var savedGifs = [Gif]()
    let cellMargin:CGFloat = 8.0
    
    @IBOutlet weak var emptyView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showWelcome()
        
        if FileManager.default.fileExists(atPath: gifsURL) {
            print("unarchiving")
            
            let gifs = NSKeyedUnarchiver.unarchiveObject(withFile: gifsURL) as! [Gif]
            self.gifs = gifs
            (UIApplication.shared.delegate as! AppDelegate).savedGifs = gifs
            print(gifs.count)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let previousGifCount = gifs.count
        gifs = (UIApplication.shared.delegate as! AppDelegate).savedGifs
        if previousGifCount != gifs.count {
            print("archiving")
            // a new gif has been added, data should be saved
            NSKeyedArchiver.archiveRootObject(gifs, toFile: gifsURL)
        }
        
        emptyView.isHidden = gifs.count > 0
        collectionView.reloadData()
        
        title = "My Collection"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.gif = sender as? Gif
        }
    }

    func showWelcome() {
        if !UserDefaults.standard.bool(forKey: "WelcomeViewSeen") {
            let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: "WelcomeViewController") as! WelcomeViewController
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    // MARK: PreviewVC Delegate methods
    
    //    func previewVC(preview: PreviewViewController, didSaveGif gif: Gif) {
    //        gif.gifData = NSData(contentsOf: gif.url as! URL)
    //        savedGifs.append(gif)
    //        NSKeyedArchiver.archiveRootObject(savedGifs, toFile: gifsFilePath)
    //        saveGifs(gifs: savedGifs)
    //    }
    //
    //    func saveGifs(gifs: [Gif]) {
    //        NSKeyedArchiver.archiveRootObject(gifs, toFile: gifsFilePath)
    //    }
    
    // MARK: CollectionView Delegate and Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCell", for: indexPath) as! GifCell
        let gif = gifs[indexPath.row]
        cell.configureForGif(gif)
        return cell
    }
    
    // MARK: CollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.size.width - (cellMargin * 2.0))/2.0
        return CGSize(width: width, height: width)
        
    }
    
    // MARK: Present DetailVC
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let gif = gifs[indexPath.row]
        performSegue(withIdentifier: "ShowDetail", sender: gif)
//        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
//        detailVC.gif = gif
//        
//        detailVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
//        present(detailVC, animated: true, completion: nil)
    }
    
    
}
