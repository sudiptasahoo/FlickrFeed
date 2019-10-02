//
//  SearchInteractor.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
import EasyNetworking

final class SearchInteractor: SearchInteractorInput {
    
    //MARK: Properties
    var httpNetworking: NetworkService!
    var presenter: SearchInteractorOutput!
    
    //MARK: Initialization
    init(httpNetworking: NetworkService, presenter: SearchInteractorOutput) {
        self.httpNetworking = httpNetworking
        self.presenter = presenter
    }
    
    //MARK: SearchInteractorInput methods
    func fetchPhotos(with searchTerm: String, page: Int) {
        httpNetworking.request(FlickrAPI.search(text: searchTerm, page: page)) {[weak self] (result: Result<FlickrFeed, Error>) in
            
            guard let self = self else { return }
            
            switch result{
            case .success(let flickrFeed):
                self.presenter.fetchPhotoCompleted(with: .success(flickrFeed))
            case .failure(let error):
                self.presenter.fetchPhotoCompleted(with: .failure(error))
            }
        }
    }
}

