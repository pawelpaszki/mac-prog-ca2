//
//  CollectionViewCell.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var muscleImage: UIImageView!
    @IBOutlet var muscleLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    var tapHandler: (()->())?
    
    func displayContent(image: UIImage, title: String) {
        muscleImage.image = image
        muscleLabel.text = title
        cellButton.setTitle(title, for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        tapHandler?()
    }
    
}
