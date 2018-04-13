//
//  FavouriteViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 06/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit
import ANLoader

class FavouriteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var exercises: [Exercise]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavourite()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let exercise: Exercise = exercises[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! FavouriteCollectionViewCell
        
        let url = URL(string: exercise.imageURL)
        
        var image:UIImage = UIImage(named: "info")!
        
        let data = try? Data(contentsOf: url!)
        DispatchQueue.main.async {
            image = UIImage(data: data!)!
            cell.displayContent(image: image, title: exercise.name)
        }
        
        cell.tapHandler = {
            self.performSegue(withIdentifier: "showFavourite", sender: self.exercises[indexPath.row].name)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let exerciseName = sender as? String
        for exercise in self.exercises {
            if exerciseName == exercise.name {
                if let vc: ExerciseViewController = segue.destination as? ExerciseViewController {
                    vc.exercise = exercise
                    break
                }
            }
        }
    }
    
    func getFavourite() {
        ANLoader.showLoading("Loading", disableUI: true)
        self.exercises = []
        let endpoint: String = "https://mac-prog.herokuapp.com/api/muscles"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            // check for any errors
            guard error == nil else {
                print("Error calling GET on " + endpoint)
                return
            }
            do {
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let muscles = json["muscles"] as? [[String: Any]] {
                    for muscle in muscles {
                        if let muscleExercises = muscle["exercises"] as? [[String: Any]] {
                            for exercise in muscleExercises {
                                var exerciseFavourite: Bool = false
                                if let exFavourite = exercise["favourite"] as? Bool {
                                    if exFavourite == true {
                                        exerciseFavourite = exFavourite
                                    } else {
                                        continue
                                    }
                                }
                                var exerciseName: String = ""
                                var exerciseImageURL: String = ""
                                var exerciseVideoURL: String = ""
                                var exerciseDescription: [String] = []
                                var exerciseDefault: Bool = false
                                if let exName = exercise["name"] as? String {
                                    exerciseName = exName
                                }
                                if let exImageURL = exercise["imageURL"] as? String {
                                    exerciseImageURL = exImageURL
                                }
                                if let exImageURL = exercise["videoURL"] as? String {
                                    exerciseVideoURL = exImageURL
                                }
                                if let exDescription = exercise["description"] as? [String] {
                                    exerciseDescription = exDescription
                                }
                                if let exDefault = exercise["default"] as? Bool {
                                    exerciseDefault = exDefault
                                }
                                
                                let newExercise: Exercise = Exercise(name: exerciseName, imageURL: exerciseImageURL, videoURL: exerciseVideoURL,
                                                                     description: exerciseDescription, favourite: exerciseFavourite, isDefault: exerciseDefault         )
                                self.exercises.append(newExercise)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        ANLoader.hide()
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
}
