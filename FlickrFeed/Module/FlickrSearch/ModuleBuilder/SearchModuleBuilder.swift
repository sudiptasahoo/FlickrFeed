//
//  SearchModuleBuilder.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit
import EasyNetworking

struct SearchModuleBuilder: SearchBuilder {
    
    //MARK: SearchBuilder method
    static func buildModule() -> SearchViewController {
        let viewController = SearchViewController()
        let router = SearchRouter(viewController: viewController)
        let presenter = SearchPresenter()
        let interactor = SearchInteractor(httpNetworking: Networking.shared, presenter: presenter)
        
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.router = router
        presenter.interactor = interactor
        
        return viewController
    }
}
