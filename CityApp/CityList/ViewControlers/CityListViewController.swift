//
//  CityListViewController.swift
//  CVApp
//
//  Created by Piotr Furmanski on 16/01/2021.
//  Copyright © 2021 Piotr Furmanski. All rights reserved.
//

import UIKit
import Services

class CityListViewController: UIViewController {
    
    private typealias CityListDataSource = CityListViewModelProtocol & UICollectionViewDataSource &
                                         UICollectionViewDelegate
    
    private struct Constants {
        static let cityDetails = "cityDetails"
        static let ok = "OK"
    }
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    weak var cityCollectionView: UICollectionView!
    
    private lazy var viewModel: CityListDataSource = {
        return CityListViewModel(service: CityService(), delegate: self)
    }()
    
    override func loadView() {
        super.loadView()
        let cityCollectionView = UICollectionView(frame: CGRect.zero,
                                                   collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout = UICollectionViewFlowLayout.init()
        cityCollectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        cityCollectionView.setCollectionViewLayout(layout, animated: true)
        self.view.addSubview(cityCollectionView)
        
        NSLayoutConstraint.activate([
            cityCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            cityCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor),
            cityCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cityCollectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        self.cityCollectionView = cityCollectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupData()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadFavourites()
        reload()
    }
    
    private func setupData() {
        cityCollectionView.register(CityListCell.self,
                                    forCellWithReuseIdentifier: String(describing: CityListCell.self))
        cityCollectionView.dataSource = viewModel
        cityCollectionView.delegate = viewModel
        viewModel.loadData(completion: nil)
    }
    
    @IBAction func showFavouritesPressed(_ sender: UISwitch) {
        viewModel.showFavouritesOnly = sender.isOn
    }
    
    
    private func setupCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        cityCollectionView.refreshControl = refreshControl
        cityCollectionView.backgroundColor = .white
    }
    
    @objc func refresh() {
        viewModel.loadData(completion: nil)
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
//        loadingIndicator.stopAnimating()
        cityCollectionView.refreshControl?.endRefreshing()
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

