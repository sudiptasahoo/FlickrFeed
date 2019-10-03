//
//  SearchViewController.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import UIKit
import ImageCache

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
    
    lazy var startupLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .orange
        lbl.font = UIFont.systemFont(ofSize: 20)
        lbl.text = Strings.defaultBlankListText
        lbl.sizeToFit()
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    lazy var searchController: UISearchController = {
        let searchVC = SearchResultController()
        searchVC.searchDelegate = self
        let controller = UISearchController(searchResultsController: searchVC)
        controller.obscuresBackgroundDuringPresentation = true
        controller.searchResultsUpdater = nil
        controller.searchBar.placeholder = Strings.searchPlaceholder
        controller.searchBar.delegate = searchVC
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
        if #available(iOS 13.0, *) {
            collectionView.backgroundColor = .systemBackground
        } else {
            collectionView.backgroundColor = .black
        }
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
        refreshUI()
    }
    
    //MARK: Private Methods
    
    //Configure Views and subviews
    private func setupViews() {
        navigationItem.title = Strings.searchVcTitle
        view.addSubview(collectionView)
        configureSearchController()
    }
    
    //MARK: configureSearchController
    private func configureSearchController() {
        navigationItem.searchController = searchController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
    
    //Apply Theming for views here
    private func themeViews() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .black
        }
    }
    
    //Apply AutoLayout Constraints
    private func setupConstraints() {
        collectionView.pinEdgesToSuperView()
    }
    
}

extension SearchViewController: SearchViewInput {
    
    //MARK: SearchViewInput
    func updateViewState(with state: ViewState) {
        viewState = state
        refreshUI()
    }
    
    fileprivate func refreshUI() {
        
        guard let viewModel = presenter?.searchViewModel else { return }
        hideCollectionView(hide: viewModel.isEmpty)
        
        switch viewState {
        case .none:
            view.addSubview(startupLabel)
            startupLabel.centerInSuperView()
        case .content, .loading:
            startupLabel.removeFromSuperview()
        case .error(let message):
            startupLabel.removeFromSuperview()
            
            //This way error handling can be improved. May be through Snackbar
            showAlert(title: Strings.error, message: message, retryAction: { [unowned self] in
                self.presenter?.fetchMorePhotos()
            })
        }
    }
    
    /// Hide/Show the collection view when required
    fileprivate func hideCollectionView(hide: Bool){
        if hide {
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
    }
    
    func resetView() {
        collectionView.reloadData()
    }
    
    func insertPhotos(at indexPaths: [IndexPath]) {
        collectionView.insertItems(at: indexPaths)
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
        
        guard let viewModel = presenter?.searchViewModel,
            let imageUrl = try? viewModel.imageUrl(at: indexPath.item) else {
                fatalError("CollectionView numberOfItems not configured correctly")
        }
        
        let cell = collectionView.dequeueReusableCell(for: indexPath) as PhotoCollectionViewCell
        cell.configure(imageURL: imageUrl, indexPath: indexPath)
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
        
        if let viewModel = presenter?.searchViewModel, !viewModel.isEmpty, viewState == .loading {
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
        guard viewState != .loading,
            !viewModel.isEmpty,
            let imageUrl = try? viewModel.imageUrl(at: indexPath.row) else {
                return
        }
        EasyImage.shared.changeDownloadPriority(for: imageUrl)
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        presenter?.didSelectPhoto(at: indexPath.item)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}

extension SearchViewController : SearchResultControllerDelegate {
    
    func didTapSearchBar(withText searchText: String) {
        if !searchText.isEmpty {
            
            //Somehow the code in SearchResultController is not working on ios13
            //Fallback code
            searchController.isActive = false
            searchController.searchBar.text = searchText
            
            presenter?.fetchPhotosWithNew(searchText)
        }
    }
}
