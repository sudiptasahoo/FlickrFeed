//
//  PhotoCollectionViewCell.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell, ReusableView {
    
    lazy var photoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(photoView)
        contentView.backgroundColor = .systemGray
        photoView.pinEdges(to: contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = UIImage()
    }
    
    func configure(imageURL: URL) {
        photoView.ss_setImage(imageURL)
    }
}
