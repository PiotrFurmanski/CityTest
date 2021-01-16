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
    }
    var tourists = [String]()

    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
