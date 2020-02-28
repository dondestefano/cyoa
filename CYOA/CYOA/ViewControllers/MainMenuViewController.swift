//
//  MainMenuViewController.swift
//  CYOA
//
//  Created by Michael De Stefano on 2020-02-11.
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
    let warningScreenID = "segueToWarningScreen"
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var newStoryButton: UIButton!
    @IBOutlet weak var myStoryButton: UIButton!
    @IBOutlet weak var titleImage: UIImageView!
    
    
    override func viewDidLoad() {
        // Sign in and get the users data from Firebase
        self.signIn()
        self.myStory.loadCurrentChapterfromDB {self.checkContinue()}
        self.myStory.readPathFromDB()
        self.myStory.player?.loadPlayerFromDB()
        super.viewDidLoad()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        self.checkContinue()
    }
    
    @IBAction func newStory(_ sender: Any) {
        if self.myStory.currentChapter.chapterNumber == 0 {
            performSegue(withIdentifier: warningScreenID, sender: (Any).self)
        } else { deleteStoryWarning() }
        
    }
    
    func deleteStoryWarning() {
        let warning = UIAlertController(title: "Warning!", message: "Starting a new story will erase your current story. \nAre you sure you want to continue?", preferredStyle: .alert)
            
            let newStory = UIAlertAction(title: "Delete my story", style: .default) {
                    action in
                let user = Auth.auth().currentUser
                let db = Firestore.firestore()
                // Mark the user as deleted
                if let user = user {
                    let docRef =  db.collection("users").document(user.uid)
                    docRef.setData(["delete" : true])
                }

                // Delete the current user from the database.
                user?.delete { error in
                  if let error = error {
                    print("Encountered an error. \(error)")
                  } else {
                  }
                }
                
                if self.auth.currentUser != nil {
                    do {
                        try self.auth.signOut()
                        } catch {
                        print("Error signing out")
                    }
                 }
                
                // Sign in with a new anonymous user.
                self.signIn()
                
                self.performSegue(withIdentifier: self.warningScreenID, sender: Any?.self)
            }
                
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

            warning.addAction(cancelAction)
            warning.addAction(newStory)
                
            present(warning, animated: true)
    }
    
    func signIn() {
        auth = Auth.auth()
        
        if self.auth.currentUser != nil {
         }
            else {
            auth.signInAnonymously() { (user, error) in
            }
        }
    }

//* Animations *//
    func checkContinue() {
        // If current chapter is anything but 0 - show continue.
        if self.myStory.currentChapter.chapterNumber != 0 {
            continueButton.isUserInteractionEnabled = true
            continueButton.alpha = 1
        } else {
            // If current chapter is 0 - hide continue.
            continueButton.isUserInteractionEnabled = false
            continueButton.alpha = 0.4
        }
    }
    
//* Segues *//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == myStorySegueID {
            let destinationVC = segue.destination as! MyStoryViewController
            destinationVC.myStory = myStory
        }
        
        else if segue.identifier == storySegueID {
            let destinationVC = segue.destination as! StoryViewController
            destinationVC.myStory = myStory
        }
        
        else if segue.identifier == newStorySegueID {
            let destinationVC = segue.destination as! NewStoryViewController
            destinationVC.newStory = myStory
        }
    }
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        if segue.source is StoryViewController {
            if let senderVC = segue.source as? StoryViewController{
                myStory = senderVC.myStory
            }
        }
    }
}
