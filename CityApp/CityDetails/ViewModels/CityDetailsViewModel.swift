//
//  CityDetailsViewModel.swift
//  CityApp
//
//  Created by Piotr Furmanski on 16/01/2021.
//  Copyright © 2021 Piotr Furmanski. All rights reserved.
//

import Foundation
import Services

protocol CityDetailsViewProtocol: AnyObject {
    func reload()
    func stopLoadingIndicator()
    func show(error: String)
}

class CityDetailsViewModel {
    private struct Constants {
        static let toursitsLabel = "Tourists amount:"
        static let ratingLabel = "Avarage rating:"
        static let favourites = "favourites"
    }
    
    private weak var delegate: CityDetailsViewProtocol?
    private let service: CityServiceProtocol
    private let cityModel: CityModel?
    private var favourites = [Int]()
    
    var tourists = [String]()
    private var rating: Double?
    
    var touritsLabelText: String {
        "\(Constants.toursitsLabel) \(tourists.count)"
    }
    
    var isFavourite: Bool {
        guard let cityModel = cityModel else { return false }
        return favourites.contains(cityModel.cityId)
    }
    
    var ratingLabelText: String {
        guard let rating = rating else { return Constants.ratingLabel }
        return "\(Constants.ratingLabel) \(rating)"
    }
    
    init(service: CityServiceProtocol, delegate: CityDetailsViewProtocol, cityModel: CityModel?) {
        self.service = service
        self.delegate = delegate
        self.cityModel = cityModel
    }
    
    func favouriteChange(to value: Bool) {
        guard let cityModel = cityModel else { return }
        if value && !favourites.contains(cityModel.cityId) {
            favourites.append(cityModel.cityId)
        } else if !value {
            if let index = favourites.firstIndex(of: cityModel.cityId) {
                favourites.remove(at: index)
            }
        }
        UserDefaults.standard.set(favourites, forKey: Constants.favourites)
    }
    
    func getData(completion: (() -> ())? = nil) {
        guard let cityModel = cityModel else { return }
        
        if let favourites = UserDefaults.standard.object(forKey: Constants.favourites) as? [Int] {
            self.favourites = favourites
        }
        
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        service.getCityTourists(for: cityModel.touristsUrl) { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let tourists):
                strongSelf.tourists = tourists
                dispatchGroup.leave()
            case .failure(let error):
                dispatchGroup.leave()
                DispatchQueue.main.async {
                    strongSelf.delegate?.show(error: error.localizedDescription)
                }
            }
        }
        
        service.getCityRating(for: cityModel.rateUrl) { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let rating):
                strongSelf.rating = rating
                dispatchGroup.leave()
            case .failure(let error):
                dispatchGroup.leave()
                DispatchQueue.main.async {
                    strongSelf.delegate?.show(error: error.localizedDescription)
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.stopLoadingIndicator()
            strongSelf.delegate?.reload()
            completion?()
        }
    }
}
