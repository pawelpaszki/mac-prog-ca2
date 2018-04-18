//
//  ViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//

import UIKit
import ANLoader

struct Muscle: Codable {
    let name: String
    let imageURL: String
    var exercises: [Exercise]
}

struct Exercise: Codable {
    let name: String
    let imageURL: String
    let videoURL: String
    let description: [String]
    let favourite: Bool
    let isDefault: Bool
}

// loader from: https://github.com/ANSCoder/ANLoader

class MuscleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var exercisePicker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return muscleNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return muscleNames[row]
    }
    
    // change font of a UIPickerView:
    // https://stackoverflow.com/questions/27455345/uipickerview-wont-allow-changing-font-name-and-size-via-delegates-attributedt
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.text = muscleNames[row]
        pickerLabel.textColor = UIColor.black
        pickerLabel.font = UIFont(name: "Roboto", size: 15)
        pickerLabel.textAlignment = NSTextAlignment.center
        return pickerLabel
    }
    
    @IBOutlet weak var muscleImageView: UIImageView!
    
    // fill an UIImageView with maintaining aspect ratio
    // https://stackoverflow.com/questions/27961884/swift-uiimageview-stretched-aspect
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        muscleImageView.image = UIImage(named: self.muscleNames[row])!
        muscleImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        muscleImageView.contentMode = .scaleAspectFit
        muscleImageView.clipsToBounds = true

    }
    
    var muscles:[Muscle] = []
    var muscleNames:[String] = []
    
    @IBOutlet weak var showEx: UIButton!
    
    
    @IBAction func showExercisesPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "showExercises", sender: self.muscles[exercisePicker.selectedRow(inComponent: 0)].name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMuscleData()
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey:"exerciseChanged")
        userDefaults.set([], forKey: "favourite")
    }
    
    // usage of local storage: https://medium.com/aviabird/the-one-with-userdefaults-aab2c2a7e170
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Muscle groups"
        let userDefaults = UserDefaults.standard
        let favouriteChanged = userDefaults.bool(forKey: "exerciseChanged")
        let exerciseAdded = userDefaults.bool(forKey: "exerciseAdded")
        if favouriteChanged == true || exerciseAdded == true{
            getMuscleData()
            userDefaults.set(false, forKey:"exerciseAdded")
            userDefaults.set(false, forKey:"exerciseChanged")
            userDefaults.set([], forKey: "favourite")
        }
        showEx.backgroundColor = UIColor.black
        muscleImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        muscleImageView.contentMode = .scaleAspectFit // OR .scaleAspectFill
        muscleImageView.clipsToBounds = true
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func getMuscleData() {
        self.muscles = []
        self.muscleNames = []
        ANLoader.showLoading("Loading", disableUI: true)
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
                // parse JSON: http://roadfiresoftware.com/2016/12/how-to-parse-json-with-swift-3/
                if let data = data,
                    let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                    let muscles = json["muscles"] as? [[String: Any]] {
                    for muscle in muscles {
                        var name: String = ""
                        var imageURL: String = ""
                        if let muscleName = muscle["name"] as? String {
                            name = muscleName
                            self.muscleNames.append(muscleName)
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
                                var exerciseDefault: Bool = false
                                if let exName = exercise["name"] as? String {
                                    exerciseName = exName
                                }
                                if let exDefault = exercise["default"] as? Bool {
                                    exerciseDefault = exDefault
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
                                                                     description: exerciseDescription, favourite: exerciseFavourite, isDefault: exerciseDefault)
                                newMuscle.exercises.append(newExercise)
                            }
                            // sort the collection
                            newMuscle.exercises = newMuscle.exercises.sorted(by: {$0.name < $1.name})
                        }
                        self.muscles.append(newMuscle)
                    }
                    DispatchQueue.main.async {
                        // sort the collections
                        self.muscles = self.muscles.sorted(by: {$0.name < $1.name})
                        if self.muscleNames.count > 0 {
                            self.muscleNames.sort()
                            self.muscleImageView.image = UIImage(named: self.muscleNames[0])!
                            self.exercisePicker.selectRow(0, inComponent: 0, animated: true)
                            self.exercisePicker.delegate = self
                        }
                        ANLoader.hide()
                    }
                }
            } catch  {
                print("error trying to convert data to JSON")
                ANLoader.hide()
                return
            }
        }
        task.resume()
    }
}

