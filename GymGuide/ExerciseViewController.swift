//
//  ExerciseViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 05/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit
import YouTubePlayer

class ExerciseViewController: UIViewController {
    
    var exercise: Exercise!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var playerView: YouTubePlayerView!
    
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
        print(exercise.description)
        var descriptionText: String = ""
        for (index, _) in exercise.description.enumerated() {
            let desc: String = exercise.description[index]
            let i = String(index + 1)
            descriptionText += i + ". " + desc + "\n\n"
        }
        self.descLabel.text = descriptionText
        self.descLabel.sizeToFit()
        playerView.loadVideoID(exercise.videoURL)
    }
    
    @IBOutlet weak var descLabel: UILabel!
    
}
