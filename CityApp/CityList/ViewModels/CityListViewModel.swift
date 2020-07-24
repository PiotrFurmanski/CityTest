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
    func showDetails(for city: CityModel)
    func stopLoadingIndicator()
    func show(error: String)
}

protocol CityListViewModelProtocol: AnyObject {
    func loadData()
}

class CityListViewModel: NSObject, CityListViewModelProtocol {
    private(set) var cityModels = [CityModel]()
    
    private weak var delegate: CityListViewProtocol?
    private let service: CityServiceProtocol
    
    init(service: CityServiceProtocol, delegate: CityListViewProtocol) {
        self.service = service
        self.delegate = delegate
    }
    
    func loadData() {
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
        cell.setup(city: cityModels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetails(for: cityModels[indexPath.row])
    }
}