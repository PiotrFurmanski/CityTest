//
//  CityListCell.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

class CityListCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    
    var cityId: Int?
    
    let viewModel = CityListCellViewModel()
    
    private struct Constants {
        static let placeholder = "cityIcon"
        static let transitionDuration = 0.3
    }
    
    func setup(city: CityModel) {
        titleLabel.text = city.name
        cityImage.image = UIImage(named: Constants.placeholder)
        cityId = city.cityId
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
