//
//  GalleryViewController.swift
//  In2-PI-Swift
//
//  Created by Terry Bu on 8/29/15.
//  Copyright (c) 2015 Terry Bu. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking
import JTSImageViewController
import MBProgressHUD

private let cellReuseIdentifier = "GalleryCell"

class GalleryViewController: ParentViewController, FacebookPhotoQueryDelegate, UICollectionViewDataSource, UICollectionViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var topImageView: UIImageView!
    var photoObjectsArray: [FBPhotoObject]?
    
    override func viewDidLoad() {
        setUpStandardUIForViewControllers()
        FacebookPhotoQuery.sharedInstance.delegate = self
        let hud = MBProgressHUD.showHUDAddedTo(view, animated: true)
        hud.labelText = "Loading..."
        hideViews()
        FacebookPhotoQuery.sharedInstance.getPhotosFromMostRecentThreeAlbums()
        topImageView.layer.shadowColor = UIColor.lightGrayColor().CGColor
        topImageView.layer.shadowOffset = CGSizeMake(2, 2)
        topImageView.layer.shadowOpacity = 1
        topImageView.layer.shadowRadius = 5.0
        let singleTap = UITapGestureRecognizer(target: self, action: Selector("displayJTSFullScreenViewForImage"))
        singleTap.numberOfTapsRequired = 1
        topImageView.userInteractionEnabled = true
        topImageView.addGestureRecognizer(singleTap)
    }
    
    private func hideViews() {
        topImageView.hidden = true
        collectionView.hidden = true
    }
    private func unhideViews() {
        topImageView.hidden = false
        collectionView.hidden = false
    }
    
    //MARK: FacebookPhotoQueryDelegate methods
    func didFinishGettingFacebookPhotos(fbPhotoObjectsArray: [FBPhotoObject]) {
        self.photoObjectsArray = fbPhotoObjectsArray
        let firstObject = photoObjectsArray![0]
        setImgInNormalSizeToTopImageView(firstObject)
        self.collectionView.reloadData()
        MBProgressHUD.hideAllHUDsForView(view, animated: true)
        unhideViews()
    }
    
    //MARK: Top Image View related methods
    private func setImgInNormalSizeToTopImageView(fbObject: FBPhotoObject) {
        //FacebookManager needs to call a new Graph API request with the object
        FacebookPhotoQuery.sharedInstance.getNormalSizePhotoURLStringFrom(fbObject
            , completion: { (normImgUrlString) -> Void in
                self.topImageView.setImageWithURL(NSURL(string: normImgUrlString ))
        })
    }
    
    func displayJTSFullScreenViewForImage() {
        var imageInfo = JTSImageInfo()
        imageInfo.image = self.topImageView.image
        imageInfo.referenceRect = self.topImageView.frame
        imageInfo.referenceView = self.topImageView.superview
        var imageViewer = JTSImageViewController(imageInfo: imageInfo, mode: JTSImageViewControllerMode.Image, backgroundStyle: JTSImageViewControllerBackgroundOptions.Scaled)
        imageViewer.showFromViewController(self, transition: JTSImageViewControllerTransition._FromOriginalPosition)
    }
    
    
    //MARK UICollectionView delegate methods
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if let photoObjectsArray = self.photoObjectsArray {
            return 1
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let photoObjectsArray = self.photoObjectsArray {
            return photoObjectsArray.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! GalleryCell
        
        //this should prevent flickering from happening
        cell.imageView.image = nil
        
        // Configure the cell
        let photoObject = photoObjectsArray![indexPath.row]
        cell.imageView!.setImageWithURL(NSURL(string: photoObject.albumSizePicURLString ))

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GalleryCell {
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    cell.contentView.layer.borderColor = UIColor.In2DeepPurple().CGColor
                }, completion: nil)
        }
        
        setImgInNormalSizeToTopImageView(photoObjectsArray![indexPath.row])
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? GalleryCell {
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    cell.contentView.layer.borderColor = UIColor.blackColor().CGColor
                }, completion: nil)
        }
    }

    deinit {
        println("gallery vc deinit checking")
    }
    
}