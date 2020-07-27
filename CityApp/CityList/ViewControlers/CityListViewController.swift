//
//  CityListViewController.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

class CityListViewController: UIViewController {
    
    private typealias CityListDataSource = CityListViewModelProtocol & UICollectionViewDataSource &
                                         UICollectionViewDelegate
    
    private struct Constants {
        static let cityDetails = "cityDetails"
        static let ok = "OK"
    }
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    private lazy var viewModel: CityListDataSource = {
        return CityListViewModel(service: CityService(), delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
    }
    
    private func setupData() {
        cityCollectionView.dataSource = viewModel
        cityCollectionView.delegate = viewModel
        viewModel.loadData()
    }
    
    private func setupCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        cityCollectionView.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        viewModel.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.cityDetails,
            let cityDetailsVC = segue.destination as? CityDetailsViewController,
            let detailsData = sender as? (CityModel, UIImage?) else { return }
        cityDetailsVC.cityModel = detailsData.0
        cityDetailsVC.cityCachedImage = detailsData.1
    }
}

extension CityListViewController: CityListViewProtocol {
    func reload() {
        cityCollectionView.reloadData()
    }
    
    func showDetails(for city: CityModel, image: UIImage?) {
        performSegue(withIdentifier: Constants.cityDetails, sender: (city, image))
    }

    func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
        cityCollectionView.refreshControl?.endRefreshing()
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

