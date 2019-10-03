//
//  UIView+Loader.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    var loaderTag: Int { return 783648 }
    
    /// Adds a loader to the center of the view
    /// - Parameter loadingText: optional, loading text shown below the activity indicator
    func startLoader(loadingText: String? = nil) {
        
        DispatchQueue.main.async {
            let blurEffect = UIBlurEffect(style: .dark)
            let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
            activityIndicatorView.center = self.center
            let loaderView = UIVisualEffectView(frame: self.frame)
            loaderView.tag = self.loaderTag
            loaderView.effect = blurEffect
            activityIndicatorView.startAnimating()
            loaderView.contentView.addSubview(activityIndicatorView)
            
            if let _loadingText = loadingText {
                let label = UILabel()
                label.text = _loadingText
                
                label.translatesAutoresizingMaskIntoConstraints = false
                label.font = UIFont.systemFont(ofSize: 20)
                label.numberOfLines = 0
                label.textColor = .purple
                label.textAlignment = .center
                loaderView.contentView.addSubview(label)
                
                NSLayoutConstraint.activate([
                    label.leadingAnchor.constraint(equalTo: loaderView.contentView.leadingAnchor, constant: 30),
                    label.trailingAnchor.constraint(equalTo: loaderView.contentView.trailingAnchor, constant: -30),
                    label.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 40),
                ])
            }
            
            self.addSubview(loaderView)
        }
    }
    
    
    func stopLoader(){
        DispatchQueue.main.async {
            self.subviews.filter(
                { $0.tag == self.loaderTag}).forEach {
                    $0.removeFromSuperview()
            }
        }
    }
}
