//
//  UIImageView+Cache.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit
import ImageCache

extension UIImageView{
    
    ///  Sets the image from the path to the UIImageView
    /// - Parameter path: The URL of the image. https://www.example.com/image.png
    /// - Parameter placeHolderImage: Placeholder image to be put on the UIImageView until the image is fetched
    func setImage(from path: URL?, placeHolderImage: UIImage? = nil) {
        
        guard let path = path else {
            self.easy_setImage(nil, placeHolderImage)
            return
        }
        
        self.easy_setImage(path, placeHolderImage)
    }
    
}
