//
//  CityDetailsViewController.swift
//  CVApp
//
//  Created by Piotr Furmanski on 16/01/2021.
//  Copyright © 2021 Piotr Furmanski. All rights reserved.
//

import UIKit
import Services

class CityDetailsViewController: UIViewController {
    private struct Constants {
        static let ok = "OK"
        static let placeholder = "cityIcon"
        
        struct Layout {
            static let margin: CGFloat = 20
            static let labelHeight: CGFloat = 40
        }
    }
    
    var cityModel: CityModel?
    var cityCachedImage: UIImage?
    
    private lazy var cityImageView: UIImageView = {
        let cityImageView = UIImageView(frame: .zero)
        cityImageView.contentMode = .scaleAspectFill
        cityImageView.backgroundColor = .clear
        cityImageView.clipsToBounds = true
        cityImageView.translatesAutoresizingMaskIntoConstraints = false
        return cityImageView
    }()
    
    private lazy var touristsLabel: UILabel = {
        let touristsLabel = UILabel(frame: .zero)
        touristsLabel.lineBreakMode = .byTruncatingTail
        touristsLabel.numberOfLines = 0
        touristsLabel.textColor = .black
        touristsLabel.textAlignment = .center
        touristsLabel.translatesAutoresizingMaskIntoConstraints = false
        touristsLabel.text = "Tourists number:"
        return touristsLabel
    }()
    
    private lazy var ratingLabel: UILabel = {
        let ratingLabel = UILabel(frame: .zero)
        ratingLabel.lineBreakMode = .byTruncatingTail
        ratingLabel.numberOfLines = 0
        ratingLabel.textColor = .black
        ratingLabel.textAlignment = .center
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingLabel.text = "Avarage rating:"
        return ratingLabel
    }()
    
    private lazy var favouriteLabel: UILabel = {
        let favouriteLabel = UILabel(frame: .zero)
        favouriteLabel.lineBreakMode = .byTruncatingTail
        favouriteLabel.numberOfLines = 0
        favouriteLabel.textColor = .black
        favouriteLabel.textAlignment = .center
        favouriteLabel.translatesAutoresizingMaskIntoConstraints = false
        favouriteLabel.text = "Favourite"
        return favouriteLabel
    }()
    
    private lazy var isFavourite: UISwitch = {
        let isFavourite = UISwitch()
        isFavourite.addTarget(self, action: #selector(isFavouriteChanged), for: .valueChanged)
        isFavourite.translatesAutoresizingMaskIntoConstraints = false
        return isFavourite
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    private lazy var viewModel: CityDetailsViewModel = {
        return CityDetailsViewModel(service: CityService(),
                                    delegate: self,
                                    cityModel: cityModel)
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(cityImageView)
        view.addSubview(touristsLabel)
        view.addSubview(ratingLabel)
        view.addSubview(favouriteLabel)
        view.addSubview(isFavourite)
        view.addSubview(loadingIndicator)

        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Constants.Layout.margin),
            cityImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: Constants.Layout.margin),
            cityImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                    constant: -Constants.Layout.margin),
            cityImageView.heightAnchor.constraint(equalTo: view.heightAnchor,
                                                  multiplier: 0.4),
            
            touristsLabel.topAnchor.constraint(equalTo: cityImageView.bottomAnchor,
                                               constant: Constants.Layout.margin),
            touristsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            touristsLabel.heightAnchor.constraint(equalToConstant: Constants.Layout.labelHeight),
            
            ratingLabel.topAnchor.constraint(equalTo: touristsLabel.bottomAnchor,
                                               constant: Constants.Layout.margin),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ratingLabel.heightAnchor.constraint(equalToConstant: Constants.Layout.labelHeight),
            
            favouriteLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor,
                                               constant: Constants.Layout.margin),
            favouriteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            favouriteLabel.heightAnchor.constraint(equalToConstant: Constants.Layout.labelHeight),
            
            isFavourite.topAnchor.constraint(equalTo: favouriteLabel.bottomAnchor,
                                             constant: Constants.Layout.margin),
            isFavourite.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            isFavourite.heightAnchor.constraint(equalToConstant: Constants.Layout.labelHeight),
            
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        touristsLabel.text = viewModel.touritsLabelText
        ratingLabel.text = viewModel.ratingLabelText
        cityImageView.image = cityCachedImage ?? UIImage(named: Constants.placeholder)
        isFavourite.isOn = viewModel.isFavourite
        setupTouristsLabelAction()
        
        viewModel.getData()
    }
    
    @objc func isFavouriteChanged(_ sender: UISwitch) {
        viewModel.favouriteChange(to: sender.isOn)
    }
    
    private func setupTouristsLabelAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showTourists))
        touristsLabel.isUserInteractionEnabled = true
        touristsLabel.addGestureRecognizer(tap)
    }
    
    @objc func showTourists(sender: UITapGestureRecognizer) {
        let touristListVC = TouristsListViewController()
        touristListVC.tourists = viewModel.tourists
        present(touristListVC, animated: true, completion: nil)
    }

}

extension CityDetailsViewController: CityDetailsViewProtocol {
    func reload() {
        touristsLabel.text = viewModel.touritsLabelText
        ratingLabel.text = viewModel.ratingLabelText
        isFavourite.isOn = viewModel.isFavourite
    }
    
    func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
