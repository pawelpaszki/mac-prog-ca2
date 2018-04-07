//
//  AddExerciseViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 06/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

class AddExerciseViewController: UIViewController {
    
    var muscleName: String!
    @IBOutlet weak var exerciseNameRequired: UILabel!
    @IBOutlet weak var videoIdRequired: UILabel!
    @IBOutlet weak var imageUrlRequired: UILabel!
    @IBOutlet weak var descriptionRequired: UILabel!
    @IBOutlet weak var createExerciseButton: UIButton!
    @IBOutlet weak var exerciseNameTextField: UITextField!
    @IBOutlet weak var videoIdTextField: UITextField!
    @IBOutlet weak var imageUrlTextField: UITextField!
    @IBOutlet var descriptionTextFieldCollection: [UITextField]!
    @IBOutlet weak var muscleNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createExerciseButton.backgroundColor = UIColor.black
    }
    
    override func viewWillAppear(_ animated: Bool) {
        muscleNameTextField.text = muscleName
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func exerciseNameValueChanged(_ sender: UITextField) {
        if sender.text == "" {
            exerciseNameRequired.isHidden = false
        } else {
            exerciseNameRequired.isHidden = true
        }
    }
    
    @IBAction func videoIdValueChanged(_ sender: UITextField) {
        if sender.text == "" {
            videoIdRequired.isHidden = false
        } else {
            videoIdRequired.isHidden = true
        }
    }
    
    @IBAction func imageUrlValueChanged(_ sender: UITextField) {
        if sender.text == "" {
            imageUrlRequired.isHidden = false
        } else {
            imageUrlRequired.isHidden = true
        }
    }
    
    @IBAction func descriptionValueChanged(_ sender: UITextField) {
        if sender.text == "" {
            descriptionRequired.isHidden = false
        } else {
            descriptionRequired.isHidden = true
        }
    }
    
    @IBAction func createExercisePressed(_ sender: UIButton) {
        if allRequiredFieldsNotEmpty() {
            
        } else {
            if exerciseNameTextField.text!.count == 0 {
                exerciseNameRequired.isHidden = false
            }
            if videoIdTextField.text!.count == 0 {
                videoIdRequired.isHidden = false
            }
            if imageUrlTextField.text!.count == 0 {
                imageUrlRequired.isHidden = false
            }
            if descriptionTextFieldCollection[0].text!.count == 0 {
                descriptionRequired.isHidden = false
            }
        }
    }
    
    func allRequiredFieldsNotEmpty() -> Bool {
        return exerciseNameTextField.text!.count > 0 && videoIdTextField.text!.count > 0
            && imageUrlTextField.text!.count > 0 && descriptionTextFieldCollection[0].text!.count > 0
    }
}
