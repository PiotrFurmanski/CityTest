//
//  CvListCell.swift
//  CVApp
//
//  Created by Piotr Furmanski on 23/07/2020.
//  Copyright © 2020 Piotr Furmanski. All rights reserved.
//

import UIKit

class CvListCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    func setup(cv: CvFile) {
        titleLabel.text = cv.filename
    }
    
}
