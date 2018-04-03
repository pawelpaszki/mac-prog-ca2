//
//  TabBarController.swift
//  GymExerciseGuide
//
//  Created by Pawel Paszki on 03/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.unselectedItemTintColor = UIColor.white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
