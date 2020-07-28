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
    func loadData(completion: (() -> ())?)
    func loadFavourites()
    var showFavouritesOnly: Bool { get set }
}

class CityListViewModel: NSObject, CityListViewModelProtocol {
    private struct Constants {
        static let favourites = "favourites"
    }
    
    var showFavouritesOnly: Bool {
        didSet {
            delegate?.reload()
        }
    }
    
    private(set) var cityModels = [CityModel]()
    
    private var filteredCities: [CityModel] {
        return showFavouritesOnly ? cityModels.filter { favourites.contains($0.cityId) } : cityModels
    }
    
    private var favourites = [Int]()
    
    private weak var delegate: CityListViewProtocol?
    private let service: CityServiceProtocol
    private let cellViewModel = CityListCellViewModel()
    
    init(service: CityServiceProtocol, delegate: CityListViewProtocol) {
        self.service = service
        self.delegate = delegate
        showFavouritesOnly = false
    }
    
    func loadFavourites() {
        if let favourites = UserDefaults.standard.object(forKey: Constants.favourites) as? [Int] {
            self.favourites = favourites
        }
    }
    
    func loadData(completion: (() -> ())? = nil) {
        loadFavourites()
        
        service.getCityList { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let cityModels):
                strongSelf.cityModels = cityModels
                DispatchQueue.main.async {
                    strongSelf.delegate?.stopLoadingIndicator()
                    strongSelf.delegate?.reload()
                    completion?()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    strongSelf.delegate?.stopLoadingIndicator()
                    strongSelf.delegate?.show(error: error.localizedDescription)
                    completion?()
                }
            }
        }
    }
    
}

extension CityListViewModel: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return filteredCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CityListCell.self),
                                                            for: indexPath) as? CityListCell else { return UICollectionViewCell() }
        
        cell.setup(city: filteredCities[indexPath.row],
                   viewModel: cellViewModel,
                   isFavorite: favourites.contains(filteredCities[indexPath.row].cityId))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetails(for: filteredCities[indexPath.row],
                              image: cellViewModel.cachedImage[filteredCities[indexPath.row].cityId])
    }
    
}
