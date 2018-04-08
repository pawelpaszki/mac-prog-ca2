//
//  AddExerciseViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 06/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit
import ANLoader
import Alamofire

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
        goBack()
    }
    
    func goBack() {
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
            ANLoader.showLoading("Loading", disableUI: true)
            var descriptionArrayString: String = ""
            for textField in descriptionTextFieldCollection {
                if (textField.text?.count)! > 0 {
                    descriptionArrayString += textField.text! + "<->"
                }
            }
            var description = String(descriptionArrayString.dropLast())
            description = String(description.dropLast())
            description = String(description.dropLast())
            let name: String = muscleName
            let exerciseName: String = exerciseNameTextField.text!
            let videoURL: String = videoIdTextField.text!
            let imageURL: String = imageUrlTextField.text!
            let urlString = "https://mac-prog.herokuapp.com/api/muscles/exercises"
            let json = "{\"muscleName\":" + "\"" + name + "\",\"exerciseName\":\"" + exerciseName +
                "\",\"videoURL\":\"" + videoURL + "\",\"imageURL\":\"" + imageURL +
                "\",\"description\":\"" + description + "\"}"
            
            let url = URL(string: urlString)!
            let jsonData = json.data(using: .utf8, allowLossyConversion: false)!
            
            var request = URLRequest(url: url)
            request.httpMethod = HTTPMethod.post.rawValue
            request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            Alamofire.request(request).responseJSON {
                (response) in
                let userDefaults = UserDefaults.standard
                userDefaults.set(true, forKey:"exerciseAdded")
                ANLoader.hide()
                print(response)
                self.goBack()
            }
            
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
