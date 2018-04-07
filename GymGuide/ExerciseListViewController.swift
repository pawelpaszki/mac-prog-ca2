//
//  ExerciseListViewController.swift
//  GymGuide
//
//  Created by Pawel Paszki on 04/04/2018.
//  Copyright © 2018 Pawel Paszki. All rights reserved.
//
import UIKit
import ANLoader

extension UIViewController {
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
}

class ExerciseListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var muscle: Muscle!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return muscle.exercises.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let exercise: Exercise = muscle.exercises[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! ExerciseCollectionViewCell
        
        let url = URL(string: exercise.imageURL)
        
        var image:UIImage = UIImage(named: "noImage")!
        
        let data = try? Data(contentsOf: url!)
        DispatchQueue.main.async {
            if (data != nil) {
                image = (UIImage(data: (data)!))!
            }
            cell.displayContent(image: image, title: exercise.name, isDefault: exercise.isDefault)
        }
        
        cell.tapHandler = {
            self.performSegue(withIdentifier: "showExercise", sender: self.muscle.exercises[indexPath.row].name)
        }
        
        cell.deleteTapHandler = {
            self.deleteExercise(name: self.muscle.exercises[indexPath.row].name)
        }
        
        return cell
    }
    
    
    @IBAction func composeTapped(_ sender: UIBarButtonItem) {
        print("compose")
    }
    
    func deleteExercise(name: String) {
        ANLoader.showLoading("Loading", disableUI: true)
        let url = URL(string: "https://mac-prog.herokuapp.com/api/muscles/deleteExercise")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "exerciseName=" + name
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error=\(String(describing: error))")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode == 200 {
                DispatchQueue.main.async {
                    var exerciseIndex: Int = 0
                    for (index, _) in self.muscle.exercises.enumerated() {
                        if self.muscle.exercises[index].name == name {
                            exerciseIndex = index
                            break
                        }
                    }
                    self.muscle.exercises.remove(at: exerciseIndex)
                    let userDefaults = UserDefaults.standard
                    userDefaults.set(true, forKey:"exerciseChanged")
                    self.collectionView.reloadData()
                    ANLoader.hide()
                }
            }
            
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            ANLoader.hide()
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showExercise" {
            let exerciseName = sender as? String
            for exercise in self.muscle.exercises {
                if exerciseName == exercise.name {
                    if let vc: ExerciseViewController = segue.destination as? ExerciseViewController {
                        vc.exercise = exercise
                        break
                    }
                }
            }
        } else {
            let name = self.muscle.name
            if let vc: AddExerciseViewController = segue.destination as? AddExerciseViewController {
                vc.muscleName = name
            }
        }
    }
}

