//
//  ViewController.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let service = CvService()
        service.getCvList { response in
            switch response {
            case .success(let cvFiles):
                service.getCv(for: cvFiles["pfcv1.json"]?.url ?? "") { (response) in
                    print(response)
                }
            case .failure(let error):
                print(error)
            }
        }
    }


}

