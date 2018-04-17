//
//  ExerciseCollectionViewCell.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

class ExerciseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var remove  : UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet var exerciseImage: UIImageView!
    @IBOutlet var exerciseLabel: UILabel!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet var defaultLabel: UILabel!
    
    var isDefaultExercise: Bool = false
    var isFavouriteExercise: Bool = false
    
    // pass a click to UIViewController https://stackoverflow.com/questions/45704441/propagate-a-custom-event-from-a-uicollectionviewcell
    var tapHandler: (()->())?
    
    var deleteTapHandler: (()->())?
    
    func displayContent(image: UIImage, title: String, isDefault: Bool) {
        exerciseImage.image = image
        exerciseLabel.text = title
        isDefaultExercise = isDefault
        cellButton.setTitle(title, for: .normal)
        // long press:
        // https://stackoverflow.com/questions/34548263/button-tap-and-long-press-gesture/34548629
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap(_:)))
        tapGesture.numberOfTapsRequired = 1
        cellButton.addGestureRecognizer(tapGesture)
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteTap(_:)))
        deleteTapGesture.numberOfTapsRequired = 1
        remove.addGestureRecognizer(deleteTapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(_:)))
        cellButton.addGestureRecognizer(longGesture)
 
    }
    
    @objc func deleteTap(_ sender: UIGestureRecognizer) {
        self.hideControls()
        deleteTapHandler?()
    }
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        tapHandler?()
    }
    
    func hideControls() {
        exerciseLabel.isHidden = false
        cancel.isHidden = true
        remove.isHidden = true
        cellButton.isHidden = false
        defaultLabel.isHidden = true
    }
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        self.hideControls()
    }
    
    @objc func longTap(_ sender: UIGestureRecognizer){
        if sender.state == .began {
            cellButton.isHidden = true
            exerciseLabel.isHidden = true
            cancel.isHidden = false
            if !isDefaultExercise {
                remove.isHidden = false
            } else {
                defaultLabel.isHidden = false
            }
        }
    }
    
}
