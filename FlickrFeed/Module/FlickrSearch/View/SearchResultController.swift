//
//  SearchResultController.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

protocol SearchResultControllerDelegate: AnyObject {
    func didTapSearchBar(withText searchText: String)
}

final class SearchResultController: UIViewController, UISearchBarDelegate {

    weak var searchDelegate: SearchResultControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            return
        }
        searchBar.text = text
        searchBar.resignFirstResponder()
        searchDelegate?.didTapSearchBar(withText: text)
    }
}
