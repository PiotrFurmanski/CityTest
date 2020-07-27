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
        static let touristsList = "touristsList"
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
        
        setupTouristsLabelAction()
        
        viewModel.getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.touristsList,
            let touristListVC = segue.destination as? TouristsListViewController,
            let touristsList = sender as? [String] else { return }
        touristListVC.tourists = touristsList
    }
    
    private func setupTouristsLabelAction() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showTourists))
        touristsLabel.isUserInteractionEnabled = true
        touristsLabel.addGestureRecognizer(tap)
    }
    
    @objc func showTourists(sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: Constants.touristsList, sender: viewModel.tourists)
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
