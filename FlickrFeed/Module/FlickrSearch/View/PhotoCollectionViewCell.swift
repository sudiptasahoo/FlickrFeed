//
//  PhotoCollectionViewCell.swift
//  FlickrFeed
//
//  Created by Sudipta Sahoo on 02/10/19.
//  Copyright © 2019 Sudipta Sahoo. All rights reserved.
//

import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell, ReusableView {
    
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
        if #available(iOS 13.0, *) {
            contentView.backgroundColor = .systemBackground
        } else {
            contentView.backgroundColor = .black
        }
        photoView.pinEdges(to: contentView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoView.image = nil
    }
    
    func configure(imageURL: URL, indexPath: IndexPath) {
        photoView.tag = indexPath.item
        photoView.setImage(from: imageURL, placeHolderImage: UIImage(named: Images.imagePlaceholder))
        
        //Useful for UI Testing
        accessibilityIdentifier = "Photo\(indexPath.row)"
    }
}
