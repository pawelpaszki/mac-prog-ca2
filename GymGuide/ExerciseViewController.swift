//
//  ExerciseViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 05/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit
import YouTubePlayer
import ANLoader

class ExerciseViewController: UIViewController {
    
    var exercise: Exercise!
    var favourite: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet var playerView: YouTubePlayerView!
    
    @IBAction func backPressed(_ sender: Any) {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBOutlet weak var favIndicator: UIBarButtonItem!
    
    @IBOutlet weak var navTopBar: UINavigationItem!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navTopBar.title = exercise.name
        let userDefaults = UserDefaults.standard
        let favouriteChanged = userDefaults.bool(forKey: "exerciseChanged")
        if favouriteChanged == false {
            favourite = exercise.favourite
        } else {
            let favouriteArray = userDefaults.object(forKey: "favourite") as? [String] ?? [String]()
            for (index, _) in favouriteArray.enumerated() {
                if favouriteArray[index] == exercise.name {
                    favourite = favouriteArray[index + 1] == "true" ? true : false
                }
            }
        }
        var descriptionText: String = ""
        for (index, _) in exercise.description.enumerated() {
            let desc: String = exercise.description[index]
            let i = String(index + 1)
            descriptionText += i + ". " + desc + "\n\n"
        }
        self.descLabel.text = descriptionText
        self.descLabel.sizeToFit()
        playerView.loadVideoID(exercise.videoURL)
        self.setFavImage(changed: false)
    }
    
    func setFavImage(changed: Bool) {
        let userDefaults = UserDefaults.standard
        if changed {
            userDefaults.set(true, forKey:"exerciseChanged")
            self.favourite = !self.favourite
            var favouriteArray = userDefaults.object(forKey: "favourite") as? [String] ?? [String]()
            var entryPresent: Bool = false
            for (index, _) in favouriteArray.enumerated() {
                if favouriteArray[index] == exercise.name {
                    entryPresent = true
                    favouriteArray[index + 1] = self.favourite == true ? "true" : "false"
                }
            }
            if entryPresent == false {
                favouriteArray.append(exercise.name)
                favouriteArray.append(self.favourite == true ? "true" : "false")
            }
            userDefaults.set(favouriteArray, forKey: "favourite")
        }
        if self.favourite == true {
            favIndicator.image = UIImage(named: "favouriteSelected")
        } else {
            favIndicator.image = UIImage(named: "favourite")
        }
    }
    
    @IBOutlet weak var descLabel: UILabel!
    
    @IBAction func favPressed(_ sender: UIBarButtonItem) {
        ANLoader.showLoading("Loading", disableUI: true)
        let url = URL(string: "https://mac-prog.herokuapp.com/api/muscles")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "PUT"
        let postString = "exerciseName=" + exercise.name
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { 
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                DispatchQueue.main.async {
                    self.setFavImage(changed: true)
                }
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            ANLoader.hide()
        }
        task.resume()
    }
}
