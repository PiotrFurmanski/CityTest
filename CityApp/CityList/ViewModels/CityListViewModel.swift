//
//  CityListViewModel.swift
//  CVApp
//
//  Created by Piotr Furmanski on 16/01/2021.
//  Copyright © 2021 Piotr Furmanski. All rights reserved.
//

import UIKit
import Services

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
        static let cellWidht: CGFloat = 100
        static let cellHeight: CGFloat = 140
    }
    
    var showFavouritesOnly: Bool {
        didSet {
            delegate?.reload()
        }
    }
    
    private(set) var cityModels = [CityModel]()
    
    var filteredCities: [CityModel] {
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
        filteredCities.count
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

extension CityListViewModel: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Constants.cellWidht, height: Constants.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}
