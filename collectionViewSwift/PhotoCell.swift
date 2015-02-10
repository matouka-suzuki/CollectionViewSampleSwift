//
//  PhotoCell.swift
//  collectionViewSwift
//
//  Created by on 2015/02/12.
//  Copyright (c) 2015年 hogehoge. All rights reserved.
//

import UIKit
import AssetsLibrary

@IBDesignable class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(CGColor: self.layer.borderColor) }
        set { self.layer.borderColor = newValue?.CGColor }
    }
    
    var asset: ALAsset? {
        set {
            if let newValue = newValue {
                let image = newValue.thumbnail()
                // take unretaind value
                self.photoImageView.image = UIImage(CGImage: image.takeUnretainedValue())
            }
        }
        get { return self.asset }
    }
    
    
}
