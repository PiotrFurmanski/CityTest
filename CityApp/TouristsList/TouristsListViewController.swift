//
//  TouristsListViewController.swift
//  CityApp
//
//  Created by Piotr Furmanski on 16/01/2021.
//  Copyright © 2021 Piotr Furmanski. All rights reserved.
//

import UIKit

class TouristsListViewController: UIViewController {
    private struct Constants {
        static let cellIdentifier = "touristCell"
        static let buttonImage = "clear"
        
        struct Layout {
            static let margin: CGFloat = 20
            static let buttonSize: CGFloat = 30
        }
    }
    var tourists = [String]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: String(describing: Constants.cellIdentifier))
        return tableView
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.addTarget(self, action: #selector(closePressed), for: .touchUpInside)
        closeButton.setImage(UIImage(systemName: Constants.buttonImage), for: .normal)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        return closeButton
    }()
    
    @objc func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        super.loadView()
        view.addSubview(tableView)
        view.addSubview(closeButton)
        view.bringSubviewToFront(closeButton)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constants.Layout.margin),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                              constant: Constants.Layout.margin),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                           constant: Constants.Layout.margin),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                                constant: -Constants.Layout.margin),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonSize),
            closeButton.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonSize)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
}

extension TouristsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tourists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = tourists[indexPath.row]
        
        return cell
    }
}
