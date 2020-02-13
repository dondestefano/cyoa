//
//  MainMenuViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-02-11.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit
import Firebase

class MainMenuViewController: UIViewController {
    
    var myStory = Story()
    let storySegueID = "segueFromMainMenuToStory"
    let myStorySegueID = "segueFromMainMenuToMyStory"
    let newStorySegueID = "newStorySegueID"
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var newStoryButton: UIButton!
    
    @IBOutlet weak var myStoryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Disable the continue button if no story has been started.
        if self.myStory.currentChapter.chapterNumber == 0 {
            continueButton.isUserInteractionEnabled = false
            continueButton.alpha = 0.4
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.myStory.currentChapter.chapterNumber != 0 {
            continueButton.isUserInteractionEnabled = true
            continueButton.alpha = 1
        }
    }
    
    @IBAction func newStory(_ sender: Any) {
        if self.myStory.currentChapter.chapterNumber == 0 {
            performSegue(withIdentifier: newStorySegueID, sender: (Any).self)
        } else {
            let warning = UIAlertController(title: "Warning!", message: "Starting a new story will erase your current story. \nAre you sure you want to continue?", preferredStyle: .alert)
            
            let newStory = UIAlertAction(title: "Delete my story", style: .default) {
                    action in
                self.myStory = Story(playerName: "")
                self.performSegue(withIdentifier: self.newStorySegueID, sender: Any?.self)
            }
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            warning.addAction(cancelAction)
            warning.addAction(newStory)
                
            present(warning, animated: true)
        }
    }
    
//* Segues *//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == myStorySegueID {
            let destinationVC = segue.destination as! MyStoryViewController
            destinationVC.myStory = myStory
        }
        
        else if segue.identifier == storySegueID {
            let destinationVC = segue.destination as! ViewController
            destinationVC.myStory = myStory
        }
        
        else if segue.identifier == newStorySegueID {
            let destinationVC = segue.destination as! ViewController
            destinationVC.myStory = myStory
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {

    }

}
