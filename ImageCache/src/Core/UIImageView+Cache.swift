//
//  UIImageView+Cache.swift
//  ImageCache
//
//  Created by Sudipta Sahoo on 15/06/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

public extension UIImageView{
    
    static let FADE_DURATION = 0.25
    
    /// Loads image from web asynchronosly and returns the image from the cache, if available
    func ss_setImage(_ url: URL?, _ placeHolderImage: UIImage? = nil){
        
        self.image = placeHolderImage
        
        guard let url = url else {return}
        
        FetchImage(cache: URLCache.shared).fetchImage(from: url) {[weak self] (image, source) in
            
            if let image = image, let strongSelf = self{
                
                switch source {
                    //Images from cache should not animate
                case .cache: strongSelf.setImage(image, animated: false)
                    
                    //Images fetched from web freshly should animate
                case .online: strongSelf.setImage(image, animated: true)
                }
            }
        }
    }
    
    private func setImage(_ image: UIImage, animated: Bool){
        
        DispatchQueue.main.async {
            if animated{
                UIView.transition(with: self, duration: UIImageView.FADE_DURATION, options: .transitionCrossDissolve, animations: {
                    self.image = image
                }, completion: nil)
            } else{
                self.image = image
            }
        }
    }
}
