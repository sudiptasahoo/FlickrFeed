//
//  SearchRouter.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

final class SearchRouter: SearchRouterInput {
    
    //MARK: Properties
    private weak var viewController: SearchViewController?
    
    
    //MARK: Initialiser
    init(viewController: SearchViewController) {
        self.viewController = viewController
    }
    
    //MARK: SearchRouterInput methods
    func routeToPhotoDetails(with photo: FlickrPhoto) {
        print(photo.title)
    }
}

