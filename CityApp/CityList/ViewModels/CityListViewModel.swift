//
//  CityListViewModel.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

protocol CityListViewProtocol: AnyObject {
    func reload()
    func showDetails(for city: CityModel, image: UIImage?)
    func stopLoadingIndicator()
    func show(error: String)
}

protocol CityListViewModelProtocol: AnyObject {
    func loadData()
    func loadFavourites()
}

class CityListViewModel: NSObject, CityListViewModelProtocol {
    private struct Constants {
        static let favourites = "favourites"
    }
    
    private(set) var cityModels = [CityModel]()
    private var favourites = [Int]()
    
    private weak var delegate: CityListViewProtocol?
    private let service: CityServiceProtocol
    
    init(service: CityServiceProtocol, delegate: CityListViewProtocol) {
        self.service = service
        self.delegate = delegate
    }
    
    func loadFavourites() {
        if let favourites = UserDefaults.standard.object(forKey: Constants.favourites) as? [Int] {
            self.favourites = favourites
        }
    }
    
    func loadData() {
        loadFavourites()
        
        service.getCityList { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let cityModels):
                strongSelf.cityModels = cityModels
                DispatchQueue.main.async {
                    strongSelf.delegate?.stopLoadingIndicator()
                    strongSelf.delegate?.reload()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    strongSelf.delegate?.stopLoadingIndicator()
                    strongSelf.delegate?.show(error: error.localizedDescription)
                }
            }
        }
    }
    
}

extension CityListViewModel: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cityModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityListCell.self),
                                                            for: indexPath) as? CityListCell else { return UICollectionViewCell() }
        
        cell.setup(city: cityModels[indexPath.row], isFavorite: favourites.contains(cityModels[indexPath.row].cityId))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cityImage: UIImage?
        if let cell = collectionView.cellForItem(at: indexPath) as? CityListCell,
            let cachedImage = cell.viewModel.cachedImage[cityModels[indexPath.row].cityId] {
            cityImage = cachedImage
        }
        delegate?.showDetails(for: cityModels[indexPath.row], image: cityImage)
    }
}
