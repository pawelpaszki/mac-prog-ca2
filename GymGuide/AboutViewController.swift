//
//  AboutViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutText: UILabel!
    let aboutString: String = "In a \"Muscles\" tab pick a muscle group and press the “show exercises” button to show the list of exercises for that muscle."
    + "\n\nIn the Exercise list, new exercise can be added by pressing the green button in the top-right corner"
    + "\n\nThe exercises added by the user can also be removed by long-pressing the exercise and then clicking the red \"x\" button"
    + "\n\nTo add the exercise, its name, youtube video ID (10 characters), image's URL and at least one execution step needs to be provided"
    + "\n\nIf any of the required fields is empty, the validation error will show up. Otherwise upon pressing the “Create exercise” button, an exercise will be created"
    + "\n\nFavourite exercises can be shown, when the \"Favourite\" tab in the bottom tabbar is pressed"
    + "\n\nThe displayed exercise details contain the name, description and the youtube video with the exercise execution steps. "
    + "\n\nThe exercises marked as favourite will have a gold star indicator in the top navigation bar"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.aboutText.text = aboutString
        self.aboutText.sizeToFit()
    }
    
}


