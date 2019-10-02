//
//  UIViewController+Alert.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String, retryAction: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if retryAction != nil {
            alertViewController.addAction(UIAlertAction(title: Strings.cancel, style: .default))
        }
        let title = (retryAction == nil) ? Strings.ok : Strings.retry
        alertViewController.addAction(UIAlertAction(title: title, style: .default) { _ in
            retryAction?()
        })
        present(alertViewController, animated: true)
    }
    
}
