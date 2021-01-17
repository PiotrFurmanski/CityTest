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
        static let ok = "OK"
        
        struct Layout {
            static let labelWidht: CGFloat = 200
            static let labelHeight: CGFloat = 48
            static let margin: CGFloat = 20
        }
    }
    
    private lazy var favouritesLabel: UILabel = {
        let titleLabel = UILabel(frame: .zero)
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Show favourites only:"
        return titleLabel
    }()
    
    private lazy var cityCollectionView: UICollectionView = {
        let cityCollectionView = UICollectionView(frame: CGRect.zero,
                                                  collectionViewLayout: UICollectionViewFlowLayout.init())
        let layout = UICollectionViewFlowLayout.init()
        cityCollectionView.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        cityCollectionView.setCollectionViewLayout(layout, animated: true)
        return cityCollectionView
    }()
    
    private lazy var favouritesSwitch: UISwitch = {
        let favouritesSwitch = UISwitch()
        favouritesSwitch.addTarget(self, action: #selector(showFavouritesPressed), for: .valueChanged)
        favouritesSwitch.translatesAutoresizingMaskIntoConstraints = false
        return favouritesSwitch
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.startAnimating()
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        return loadingIndicator
    }()
    
    private lazy var viewModel: CityListDataSource = {
        return CityListViewModel(service: CityService(), delegate: self)
    }()
    
    override func loadView() {
        super.loadView()
        view.addSubview(cityCollectionView)
        view.addSubview(favouritesLabel)
        view.addSubview(favouritesSwitch)
        view.addSubview(loadingIndicator)
        view.bringSubviewToFront(loadingIndicator)

        NSLayoutConstraint.activate([
            favouritesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                 constant: Constants.Layout.margin),
            favouritesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                                     constant: Constants.Layout.margin/2),
            favouritesLabel.widthAnchor.constraint(equalToConstant: Constants.Layout.labelWidht),
            favouritesLabel.heightAnchor.constraint(equalToConstant: Constants.Layout.labelHeight),
            
            cityCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            cityCollectionView.topAnchor.constraint(equalTo: favouritesLabel.bottomAnchor,
                                                    constant: Constants.Layout.margin),
            
            favouritesSwitch.leadingAnchor.constraint(equalTo: favouritesLabel.trailingAnchor,
                                                      constant: Constants.Layout.margin/2),
            favouritesSwitch.centerYAnchor.constraint(equalTo: favouritesLabel.centerYAnchor),
            
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
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
    
    @objc func showFavouritesPressed(_ sender: UISwitch) {
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
}

extension CityListViewController: CityListViewProtocol {
    func reload() {
        cityCollectionView.reloadData()
    }
    
    func showDetails(for city: CityModel, image: UIImage?) {
        let cityDetailsVC = CityDetailsViewController()
        cityDetailsVC.cityModel = city
        cityDetailsVC.cityCachedImage = image
        present(cityDetailsVC, animated: true, completion: nil)
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

