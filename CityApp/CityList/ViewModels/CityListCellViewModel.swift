//
//  CityListCellViewModel.swift
//  CityApp
//
//  Created by Piotr Furmanski on 24/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

protocol CityListCellViewModelProtocol: AnyObject {
    func loadImage(id: Int,  completion: @escaping (_ image: UIImage?, _ id: Int) -> ())
}

class CityListCellViewModel {
    private(set) var cachedImage = [Int: UIImage]()
    
    func loadImage(urlString: String, id: Int,  completion: @escaping (_ image: UIImage?, _ id: Int) -> ()) {
        if let image = cachedImage[id] {
            completion(image, id)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    strongSelf.cachedImage[id] = image
                    DispatchQueue.main.async {
                        completion(image, id)
                    }
                }
            }
        }
    }
}
