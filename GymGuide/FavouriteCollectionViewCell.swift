//
//  FavouriteCollectionViewCell.swift
//  GymGuide
//
//  Created by Pawel Paszki on 06/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var exerciseImage: UIImageView!
    @IBOutlet var exerciseLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    
    // pass a click to UIViewController https://stackoverflow.com/questions/45704441/propagate-a-custom-event-from-a-uicollectionviewcell
    var tapHandler: (()->())?
    
    func displayContent(image: UIImage, title: String) {
        exerciseImage.image = image
        exerciseLabel.text = title
        cellButton.setTitle(title, for: .normal)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        tapHandler?()
    }
    
}
