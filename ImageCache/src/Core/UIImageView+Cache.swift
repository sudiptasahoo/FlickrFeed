//
//  UIImageView+Cache.swift
//  ImageCache
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

private var imageURLKey: Void?

public extension UIImageView{
    
    static let FADE_DURATION = 0.25
    
    private var imageURL: String? {
        get {
            return objc_getAssociatedObject(self, &imageURLKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &imageURLKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// Loads image from web asynchronosly and returns the image from the cache, if available
    func easy_setImage(_ url: URL?, _ placeHolderImage: UIImage? = nil){
        
        self.image = placeHolderImage
        
        guard let url = url else {return}
        
        //Setting this for future use, after image is downloaded from the server
        imageURL = url.absoluteString
        
        EasyImage.shared.downloadImage(withURL: url) {[weak self] (url, image, source) in
            
            if let image = image, let strongSelf = self, url.absoluteString == strongSelf.imageURL {
                
                switch source {
                //Images from cache should not animate
                case .cache: strongSelf.setImage(image, animated: false)
                    
                //Images fetched from web freshly should animate
                case .online:
                    DispatchQueue.main.async {
                        strongSelf.setImage(image, animated: true)
                    }
                }
            }
        }
    }
    
    private func setImage(_ image: UIImage, animated: Bool){
        
        if animated{
            UIView.transition(with: self, duration: UIImageView.FADE_DURATION, options: .transitionCrossDissolve, animations: {
                self.image = image
            }, completion: nil)
        } else{
            self.image = image
        }
    }
}
