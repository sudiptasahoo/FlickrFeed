//
//  MockUtil.swift
//  FlickrFeedTests
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import Foundation
@testable import Flickr_Feed

struct MockUtil {
    
    static let shared = MockUtil()
    
    var mockPhotos: [FlickrPhoto] {
        
        var photos = [FlickrPhoto]()
        for index in 0...3 {
            let photo = FlickrPhoto(id: String(index), owner: "flickr", secret: "123", server: "123", farm: 1, title: "testing title", ispublic: 1, isfriend: 1, isfamily: 1)
            photos.append(photo)
        }
        return photos
    }
}
