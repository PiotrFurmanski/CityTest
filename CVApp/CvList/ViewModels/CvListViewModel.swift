//
//  CvListViewModel.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

protocol CvListViewProtocol: AnyObject {
    func reload()
    func showDetails(for cv: CvFile)
    func stopLoadingIndicator()
    func show(error: String)
}

protocol CvListViewModelProtocol: AnyObject {
    func loadData()
}

class CvListViewModel: NSObject, CvListViewModelProtocol {
    private(set) var cvFiles = [CvFile]()
    
    private weak var delegate: CvListViewProtocol?
    private let service: CvServiceProtocol
    
    init(service: CvServiceProtocol, delegate: CvListViewProtocol) {
        self.service = service
        self.delegate = delegate
    }
    
    func loadData() {
        service.getCvList { [weak self] response in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let cvFiles):
                strongSelf.cvFiles = cvFiles.map { $0.value }
                DispatchQueue.main.async {
                    strongSelf.delegate?.stopLoadingIndicator()
                    strongSelf.delegate?.reload()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    strongSelf.delegate?.stopLoadingIndicator()
                    strongSelf.delegate?.show(error: error.localizedDescription)
                }
            }
        }
    }
    
}

extension CvListViewModel: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return cvFiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: CvListCell.self),
                                                            for: indexPath) as? CvListCell else { return UICollectionViewCell() }
        cell.setup(cv: cvFiles[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.showDetails(for: cvFiles[indexPath.row])
    }
}
