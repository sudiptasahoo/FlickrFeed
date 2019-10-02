//
//  UIView+Autolayout.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    //MARK: AutoLayout
    func pinEdgesToSuperView(constant: CGFloat = 0) {
        guard let superview = superview else {
            preconditionFailure("superview is missing for this view")
        }
        translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11, *) {
            safeAreaEdges(to: superview, constant: constant)
        } else {
            pinEdges(to: superview, constant: constant)
        }
    }
    
    func safeAreaEdges(to superview: UIView, constant: CGFloat) {
        if #available(iOS 11, *) {
            let layoutGuide = superview.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: constant),
                bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: constant),
                leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: constant),
                trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: constant)
            ])
        }
    }
    
    func pinEdges(to view: UIView, constant: CGFloat = 0) {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.topAnchor),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
//    func centerInSuperView() {
//        guard let superview = superview else {
//            fatalError("superview is missing for this view")
//        }
//        NSLayoutConstraint.activate([
//            centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//            centerYAnchor.constraint(equalTo: superview.centerYAnchor)
//        ])
//    }

}
