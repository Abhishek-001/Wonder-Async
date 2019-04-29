//
//  ViewController.swift
//  Pinterest-SoulVana
//
//  Created by Abhishek.Rathi on 22/04/19.
//  Copyright © 2019 Abhishek.Rathi. All rights reserved.
//

import UIKit
import Wonder_Async

class HomeCollectionViewController: UICollectionViewController  {
    
    let cellPadding : CGFloat = 8
    var cellWidth : CGFloat?
    var unsplashImages = [UnsplashImage]() {
        // Reloads collectionview Whenever data is changed.
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    var loadCount = 0
    var refresher:UIRefreshControl!
    var isFetchingMore = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateCellWidth()
        
        self.refresher = UIRefreshControl()
        self.refresher.tintColor = UIColor.red
        self.refresher.addTarget(self, action: #selector(fetchMoreImages), for: .valueChanged)
        self.collectionView!.refreshControl = refresher
        
        // Setup Configurable Cache
        CacheManager.setupCache(memoryCapacityMB: 10)
        
        loadImages()
    }
    
    fileprivate func calculateCellWidth() {
        let totalWidth = view.frame.width
        cellWidth = totalWidth/2 - 2 * cellPadding
    }
    
    fileprivate func loadImages() {
        let testUrl = "http://pastebin.com/raw/wgkJgazE"
        
        UnsplashImage.getImages(urlString: testUrl) { (images) in
            self.unsplashImages = images
        }
    }
    
    @objc fileprivate func fetchMoreImages(){
        
        // fetching photos from unsplash User's profile provided in Test json.
        // Need Unplash Client id to fetch user's images.
        loadCount += 1

        if unsplashImages.count < loadCount { return }
        
        let unsplashClientID = "?client_id=5ee9e0777c98176231202d428478911d65739428affef15a0b3cf152cf417fc0"

        let profileUrl = unsplashImages[loadCount].user.links.photos + unsplashClientID
        
        UnsplashImage.getImages(urlString: profileUrl) { (images) in
            self.isFetchingMore = false
            
            DispatchQueue.main.async {
                self.refresher.endRefreshing()
            }
            
            self.unsplashImages.append(contentsOf: images)
        }
    
    }
    
    // Clear ImageView Cache incase of low app memory warning
    override func didReceiveMemoryWarning() {
        URLCache.shared.removeAllCachedResponses()
    }
  
}

extension HomeCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return unsplashImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homeCollectionViewCell", for: indexPath)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let homePinCell = cell as? HomePinCell {
            let urlString = unsplashImages[indexPath.row].urls.raw
            homePinCell.imageView.loadImage(urlString: urlString + "?&w=\(cellWidth)&h=\(cellWidth!*1.5)")
        }
        
        if indexPath.row > unsplashImages.count - 4 && !isFetchingMore && loadCount <= 10 {
            fetchMoreImages()
            isFetchingMore = true
            print("Fetching More data")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth!, height: cellWidth!*1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: cellPadding, bottom: 4, right: cellPadding)
    }
    
    // For individual cell Vertical spacing in a section
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellPadding
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "popupImageSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popupImageSegue" {
            let destinationVC = segue.destination as! PopupImageViewController
            let indexPath = sender as! IndexPath
            let url = unsplashImages[indexPath.row].urls.raw
            destinationVC.imageUrl = url
        }
    }
}

