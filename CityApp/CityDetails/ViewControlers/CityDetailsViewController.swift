//
//  CityDetailsViewController.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

class CityDetailsViewController: UIViewController {
    private struct Constants {
        static let ok = "OK"
        static let placeholder = "cityIcon"
    }
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var touristsLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityImage: UIImageView!
    var cityModel: CityModel?
    var cityCachedImage: UIImage?
    
    private lazy var viewModel: CityDetailsViewModel = {
        return CityDetailsViewModel(service: CityService(),
                                    delegate: self,
                                    cityModel: cityModel)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        touristsLabel.text = viewModel.touritsLabelText
        ratingLabel.text = viewModel.ratingLabelText
        cityImage.image = cityCachedImage ?? UIImage(named: Constants.placeholder)
        
        viewModel.getData()
    }

}

extension CityDetailsViewController: CityDetailsViewProtocol {
    func reload() {
        touristsLabel.text = viewModel.touritsLabelText
        ratingLabel.text = viewModel.ratingLabelText
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
