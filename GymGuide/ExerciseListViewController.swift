//
//  ExerciseListViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//
import UIKit

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

class ExerciseListViewController: UIViewController {
    
    var muscle: Muscle!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var navTopBar: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navTopBar.title = muscle.name
    }
    @IBAction func backPressed(_ sender: UIButton) {
        self.performSegueToReturnBack()
    }
}

