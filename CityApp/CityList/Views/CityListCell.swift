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
    var cityId: Int?
    
    private struct Constants {
        static let placeholder = "cityIcon"
        static let checkmark = "checkmark"
        static let transitionDuration = 0.3
        static let labelHeight: CGFloat = 28
        static let labelTop: CGFloat = 8
        static let checkmarkSize: CGFloat = 30
    }
    
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    private lazy var cityImageView: UIImageView = {
        let cityImage = UIImageView(frame: .zero)
        cityImage.contentMode = .scaleAspectFill
        cityImage.backgroundColor = .clear
        cityImage.clipsToBounds = true
        cityImage.translatesAutoresizingMaskIntoConstraints = false
        return cityImage
    }()
    
    private lazy var favouriteIcon: UIImageView = {
        let favouriteIcon = UIImageView(frame: .zero)
        favouriteIcon.contentMode = .scaleAspectFill
        favouriteIcon.backgroundColor = .clear
        favouriteIcon.tintColor = .green
        favouriteIcon.clipsToBounds = true
        favouriteIcon.translatesAutoresizingMaskIntoConstraints = false
        favouriteIcon.image = UIImage(systemName: Constants.checkmark)
        return favouriteIcon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(cityImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(favouriteIcon)
        contentView.bringSubviewToFront(favouriteIcon)
        contentView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: topAnchor),
            cityImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cityImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: cityImageView.bottomAnchor,
                                            constant: Constants.labelTop),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: Constants.labelHeight),
            
            favouriteIcon.topAnchor.constraint(equalTo: topAnchor),
            favouriteIcon.trailingAnchor.constraint(equalTo: trailingAnchor),
            favouriteIcon.widthAnchor.constraint(equalToConstant: Constants.checkmarkSize),
            favouriteIcon.heightAnchor.constraint(equalToConstant: Constants.checkmarkSize)
        ])
    }
    
    func setup(city: CityModel, viewModel: CityListCellViewModel, isFavorite: Bool) {
        favouriteIcon.isHidden = !isFavorite
        titleLabel.text = city.name
        cityImageView.image = viewModel.cachedImage[city.cityId] ?? UIImage(named: Constants.placeholder)
        cityId = city.cityId
        
        guard viewModel.cachedImage[city.cityId] == nil else { return }
        
        viewModel.loadImage(urlString: city.imageUrl, id: city.cityId) { [weak self] (image, cityId) in
            guard let strongSelf = self, strongSelf.cityId == cityId else { return }
            if let image = image {
                UIView.transition(with: strongSelf.cityImageView,
                                  duration: Constants.transitionDuration,
                                  options: .transitionCrossDissolve, animations: {
                                    strongSelf.cityImageView.image = image
                                  })
            }
        }
    }
    
}
