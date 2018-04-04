//
//  ViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit

struct Muscle: Codable {
    let name: String
    let imageURL: String
    var exercises: [Exercise]
}

struct Exercise: Codable {
    let name:String
    let imageURL:String
    let videoURL:String
    let description:[String]
    let favourite:Bool
}

class MuscleViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var muscles:[Muscle] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        getMuscleData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return muscles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let muscle: Muscle = muscles[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        
        let url = URL(string: muscle.imageURL)
        
        var image:UIImage = UIImage(named: "info")!
        
        let data = try? Data(contentsOf: url!)
        DispatchQueue.main.async {
            image = UIImage(data: data!)!
            cell.displayContent(image: image, title: muscle.name)
        }
        
        cell.tapHandler = {
            self.performSegue(withIdentifier: "showExercises", sender: self.muscles[indexPath.row].name)
            //print(self.muscles[indexPath.row].name)
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let muscleName = sender as? String
        for muscle in self.muscles {
            if muscleName == muscle.name {
                if let vc: ExerciseListViewController = segue.destination as? ExerciseListViewController {
                    vc.muscle = muscle
                    break
                }
                
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Muscle groups"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getMuscleData() {
        self.muscles = []
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
                        var name: String = ""
                        var imageURL: String = ""
                        if let muscleName = muscle["name"] as? String {
                            name = muscleName
                        }
                        if let muscleImageURL = muscle["imageURL"] as? String {
                            imageURL = muscleImageURL
                        }
                        var newMuscle: Muscle = Muscle(name: name, imageURL: imageURL, exercises: [])
                        if let muscleExercises = muscle["exercises"] as? [[String: Any]] {
                            for exercise in muscleExercises {
                                var exerciseName: String = ""
                                var exerciseImageURL: String = ""
                                var exerciseVideoURL: String = ""
                                var exerciseDescription: [String] = []
                                var exerciseFavourite: Bool = false
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
                                if let exFavourite = exercise["favourite"] as? Bool {
                                    exerciseFavourite = exFavourite
                                }
                                let newExercise: Exercise = Exercise(name: exerciseName, imageURL: exerciseImageURL, videoURL: exerciseVideoURL,
                                                                     description: exerciseDescription, favourite: exerciseFavourite)
                                newMuscle.exercises.append(newExercise)
                            }
                        }
                        self.muscles.append(newMuscle)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
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

