//
//  ExerciseListViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//
import UIKit

class ExerciseListViewController: UIViewController {
    
    var muscle: Muscle!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBOutlet weak var navTopBar: UINavigationItem!
    
    @IBOutlet weak var tabBar: UITabBar!
    override func viewWillAppear(_ animated: Bool) {
        self.navTopBar.title = muscle.name
        self.tabBar.unselectedItemTintColor = UIColor.white
    }
}

