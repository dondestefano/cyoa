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
    var db: Firestore!
    var auth: Auth!
    let storySegueID = "segueFromMainMenuToStory"
    let myStorySegueID = "segueFromMainMenuToMyStory"
    let newStorySegueID = "mainMenuToNewStorySegueID"
    
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var newStoryButton: UIButton!
    
    @IBOutlet weak var myStoryButton: UIButton!
    
    override func viewDidLoad() {
        self.signIn()
        self.myStory.loadCurrentChapterfromDB()
        self.myStory.readPathFromDB()
        self.myStory.player?.loadPlayerFromDB()
        print(self.myStory.currentChapter.chapterNumber)
        super.viewDidLoad()
        
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
        } else { deleteStoryWarning() }
        
    }
    
    func deleteStoryWarning() {
        let warning = UIAlertController(title: "Warning!", message: "Starting a new story will erase your current story. \nAre you sure you want to continue?", preferredStyle: .alert)
            
            let newStory = UIAlertAction(title: "Delete my story", style: .default) {
                    action in
                let user = Auth.auth().currentUser
                // Delete the current user from the database.
                user?.delete { error in
                  if let error = error {
                    print("Encountered an error. \(error)")
                  } else {
                    print("Successfully deleted")
                  }
                }
                
                if let user = self.auth.currentUser {
                    print(user.uid)
                    do {
                        try self.auth.signOut()
                        } catch {
                        print("Error signing out")
                    }
                 }
                
                // Sign in with a new anonymous user.
                self.signIn()
                
                self.performSegue(withIdentifier: self.newStorySegueID, sender: Any?.self)
            }
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            warning.addAction(cancelAction)
            warning.addAction(newStory)
                
            present(warning, animated: true)
    }
    
    func signIn() {
        auth = Auth.auth()
        
        if let user = self.auth.currentUser {
            print(user.uid)
         }
            else {
            print("got here")
            auth.signInAnonymously() { (user, error) in
            }
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
            let destinationVC = segue.destination as! NewStoryViewController
            destinationVC.newStory = myStory
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        if segue.source is ViewController {
            if let senderVC = segue.source as? ViewController{
                myStory = senderVC.myStory
            }
        }
    }
}
