//
//  AppRouter.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

final public class AppRouter {
    
    @discardableResult
    func configureRootViewController(inWindow window: UIWindow?) -> Bool {
        let searchVc = SearchModuleBuilder.buildModule()
        let navigationController = UINavigationController(rootViewController: searchVc)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
