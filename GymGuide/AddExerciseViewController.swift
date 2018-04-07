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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(muscleName)
        createExerciseButton.backgroundColor = UIColor.black
    }
    
    @IBAction func backPressed(_ sender: UIButton) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBOutlet weak var createExerciseButton: UIButton!
}
