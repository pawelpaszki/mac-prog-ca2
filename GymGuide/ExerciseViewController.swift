//
//  ExerciseViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 05/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

class ExerciseViewController: UIViewController {
    
    var exercise: Exercise!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func backPressed(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBOutlet weak var navTopBar: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navTopBar.title = exercise.name
    }
}
