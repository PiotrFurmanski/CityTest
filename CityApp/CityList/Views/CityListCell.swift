//
//  CityListCell.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit
import Services

class CityListCell: UICollectionViewCell {
    weak var titleLabel: UILabel!
    weak var cityImage: UIImageView!
    weak var favouriteIcon: UIImageView!
    
    var cityId: Int?
    
    private struct Constants {
        static let placeholder = "cityIcon"
        static let transitionDuration = 0.3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        let label = UILabel(frame: .zero)
        titleLabel = label
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        let imageView = UIImageView(frame: .zero)
        cityImage = imageView
        cityImage.contentMode = .scaleAspectFill
        cityImage.backgroundColor = .clear
        cityImage.clipsToBounds = true
        
        cityImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(cityImage)
        contentView.addSubview(titleLabel)
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            cityImage.topAnchor.constraint(equalTo: topAnchor),
            cityImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            cityImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cityImage.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    func setup(city: CityModel, viewModel: CityListCellViewModel, isFavorite: Bool) {
//        favouriteIcon.isHidden = !isFavorite
        titleLabel.text = city.name
        cityImage.image = viewModel.cachedImage[city.cityId] ?? UIImage(named: Constants.placeholder)
        cityId = city.cityId
        
        guard viewModel.cachedImage[city.cityId] == nil else { return }
        
        viewModel.loadImage(urlString: city.imageUrl, id: city.cityId) { [weak self] (image, cityId) in
            guard let strongSelf = self, strongSelf.cityId == cityId else { return }
            if let image = image {
                UIView.transition(with: strongSelf.cityImage,
                                  duration: Constants.transitionDuration,
                                  options: .transitionCrossDissolve, animations: {
                                    strongSelf.cityImage.image = image
                                  })
            }
        }
    }
    
}
