//
//  UIImage+Cache.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit
import ImageCache

extension UIImageView{
    
    /**
     Sets the image from the path to the UIImageView
     if path starts with http or https then image is directly fetched from this path
     else path is prefixed with BASE_URL and then image is fetched
     
     - parameter path: The URL of the image. https://www.example.com/image.png or /image.png
     - paramter placeHolderImage: Placeholder image to be put on the UIImageView until the image is fetched
 */
    func setImage(_ path: URL?, placeHolderImage: UIImage? = nil){
        
        guard let path = path else {
            self.ss_setImage(nil, placeHolderImage)
            return
        }
        
        self.ss_setImage(path, placeHolderImage)
    }

}
