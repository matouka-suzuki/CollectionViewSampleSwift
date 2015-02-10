//
//  ViewController.swift
//  collectionViewSwift
//
//  Created by on 2015/02/10.
//  Copyright (c) 2015年 hogehoge. All rights reserved.
//

import UIKit
import AssetsLibrary

class ViewController: UIViewController{
    
    struct Constants {
        static let PhotoCellReuseIdentifier = "PhotoCell"
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var assets: Array<ALAsset>! = nil
    
    private struct defaultInstance{
        static let assetsLibrary = ALAssetsLibrary()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Success Callback
        let resultBlock: ALAssetsLibraryGroupsEnumerationResultsBlock = {assetGroup, stop in
            if assetGroup == nil { return }
            var tmpList = Array<ALAsset>()
            assetGroup.enumerateAssetsUsingBlock({ (result: ALAsset!, index: Int, stop: UnsafeMutablePointer<ObjCBool>) in
                if result != nil {
                    tmpList.append(result)
                }
            })
            self.assets = tmpList
            self.collectionView.reloadData()
        }
        // Failure Callback
        let failureBlock: ALAssetsLibraryAccessFailureBlock = { error in
        }
        
        defaultInstance.assetsLibrary.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: resultBlock, failureBlock: failureBlock)
    }
    
    @IBAction func takePhotoButtonTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) == false {
            return
        }
        
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        pickerController.allowsEditing = false
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func albumsButtonTapped(sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) == false {
            return
        }
        
        let pickerController = UIImagePickerController()
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.allowsEditing = false
        pickerController.delegate = self
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.assets != nil ? self.assets.count : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.PhotoCellReuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        let asset = self.assets[indexPath.row]
        cell.asset = asset
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = self.assets[indexPath.row]
        let defaultRep = asset.defaultRepresentation()
        let image = UIImage(CGImage: defaultRep.fullScreenImage()!.takeUnretainedValue(), scale: CGFloat(defaultRep.scale()), orientation: UIImageOrientation.Up)
        
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        // Do something
    }
}

