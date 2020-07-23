//
//  CvListViewController.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

class CvListViewController: UIViewController {
    
    private typealias CvListDataSource = CvListViewModelProtocol & UICollectionViewDataSource &
                                         UICollectionViewDelegate
    
    private struct Constants {
        static let cvDetails = "cvDetails"
        static let ok = "OK"
    }
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cvCollectionView: UICollectionView!
    
    private lazy var viewModel: CvListDataSource = {
        return CvListViewModel(service: CvService(), delegate: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupCollectionView()
    }
    
    private func setupData() {
        cvCollectionView.dataSource = viewModel
        cvCollectionView.delegate = viewModel
        viewModel.loadData()
    }
    
    private func setupCollectionView() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        cvCollectionView.refreshControl = refreshControl
    }
    
    @objc func refresh() {
        viewModel.loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == Constants.cvDetails,
            let cvDetailsVC = segue.destination as? CvDetailsViewController,
            let cvFile = sender as? CvFile else { return }
        cvDetailsVC.cvFile = cvFile
    }
}

extension CvListViewController: CvListViewProtocol {
    func reload() {
        cvCollectionView.reloadData()
    }
    
    func showDetails(for cv: CvFile) {
        performSegue(withIdentifier: Constants.cvDetails, sender: cv)
    }

    func stopLoadingIndicator() {
        loadingIndicator.stopAnimating()
        cvCollectionView.refreshControl?.endRefreshing()
    }
    
    func show(error: String) {
        let alert = UIAlertController(title: "", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

