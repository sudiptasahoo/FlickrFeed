//
//  SearchViewController.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit

enum ViewState {
    case none
    case loading
    case content
}

final class SearchViewController: UIViewController {
    
    //MARK: Properties
    var presenter: SearchViewOutput?
    var viewState: ViewState = .none
    
    //MARK: Initialization
    override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 30))
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = Strings.searchPlaceholder
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController()
        if #available(iOS 11, *) {
            controller.obscuresBackgroundDuringPresentation = true
        } else {
            controller.dimsBackgroundDuringPresentation = true
        }
        controller.searchResultsUpdater = nil
        controller.searchBar.delegate = self
        controller.searchBar.placeholder = Strings.searchPlaceholder
        return controller
    }()
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let spacing = Defaults.defaultCellSpacing
        let itemSize: CGFloat = (UIScreen.main.bounds.width - (Defaults.gridNoOfColumns - spacing) - 2) / Defaults.gridNoOfColumns
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing
        layout.footerReferenceSize = CGSize(width: Metrics.screenWidth, height: 50)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        return layout
    }()
    
    lazy var collectionView : UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PhotoCollectionViewCell.self)
        collectionView.register(LoadingView.self, ofKind: UICollectionView.elementKindSectionFooter)
        return collectionView
    }()
    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        themeViews()
        setupConstraints()
        presenter?.fetchPhotos(with: "car")
    }
    
    //MARK: Private Methods
    
    //Configure Views and subviews
    private func setupViews() {
        self.title = Strings.searchVcTitle
        view.addSubview(collectionView)
        configureSearchController()
    }
    
    //MARK: configureSearchController
    private func configureSearchController() {
        #warning("Not wokring on iOS13")
        if #available(iOS 11, *) {
            navigationItem.searchController = searchController
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    //Apply Theming for views here
    private func themeViews() {
        view.backgroundColor = .white
    }
    
    
    //Apply AutoLayout Constraints
    private func setupConstraints() {
        collectionView.pinEdgesToSuperView()
    }
    
    //MARK: SearchViewInput
}

extension SearchViewController: SearchViewInput {
    
    func refreshUI(using result: SearchResultState) {
        #warning("Reload only required cells")
        collectionView.reloadData()
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    //MARK: UICollectionViewDataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return presenter?.searchViewModel.photoCount ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let viewModel = presenter?.searchViewModel else {
            fatalError("CollectionView numberOfItems not configured correctly")
        }

        let cell = collectionView.dequeueReusableCell(for: indexPath) as PhotoCollectionViewCell
        cell.configure(imageURL: viewModel.imageUrl(at: indexPath.item))
        return cell
    }
    
    //MARK: Loading Footer
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath) as LoadingView
            return footerView
        default:
            assert(false, "Unexpected supplementary element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if let _ = presenter?.searchViewModel, viewState == .loading {
            return CGSize(width: Metrics.screenWidth, height: 50)
        }
        return CGSize.zero
    }
    
    //MARK: Load More logic
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = presenter?.searchViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.photoCount - 1) else {
            return
        }
        presenter?.fetchMorePhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let viewModel = presenter?.searchViewModel else { return }
        guard viewState != .loading, indexPath.row == (viewModel.photoCount - 1) else {
            return
        }
        let imageURL = viewModel.imageUrl(at: indexPath.row)
        #warning("priority down for image download")
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter?.didSelectPhoto(at: indexPath.item)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    func insertPhotos(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
    }
}

extension SearchViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchTerm = searchBar.text, !searchTerm.isEmpty {
            presenter?.fetchPhotos(with: searchTerm)
        }
    }
}
