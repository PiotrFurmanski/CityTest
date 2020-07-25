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
    }
    
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var touristsLabel: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityImage: UIImageView!
    var cityModel: CityModel?
    
    private lazy var viewModel: CityDetailsViewModel = {
        return CityDetailsViewModel(service: CityService(),
                                    delegate: self,
                                    cityModel: cityModel)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        touristsLabel.text = viewModel.touritsLabelText
        ratingLabel.text = viewModel.ratingLabelText
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
