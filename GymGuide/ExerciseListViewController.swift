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
        
        var image:UIImage = UIImage(named: "info")!
        
        let data = try? Data(contentsOf: url!)
        DispatchQueue.main.async {
            image = UIImage(data: data!)!
            cell.displayContent(image: image, title: exercise.name, isDefault: exercise.isDefault)
        }
        
        cell.tapHandler = {
            self.performSegue(withIdentifier: "showExercise", sender: self.muscle.exercises[indexPath.row].name)
        }
        
        cell.deleteTapHandler = {
            print("delete clicked")
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let exerciseName = sender as? String
        for exercise in self.muscle.exercises {
            if exerciseName == exercise.name {
                if let vc: ExerciseViewController = segue.destination as? ExerciseViewController {
                    vc.exercise = exercise
                    break
                }
            }
        }
    }
}

