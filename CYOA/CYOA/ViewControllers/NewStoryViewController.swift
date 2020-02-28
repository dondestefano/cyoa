//
//  NewStoryViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-02-13.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit
import Firebase

class NewStoryViewController: UIViewController {

    var newStory = Story()
    let storySegueID = "newStoryToStorySegueID"
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var startStoryButton: UIButton!
    @IBOutlet weak var newStoryTextLabel: UILabel!
    
    override func viewDidLoad() {
        newStoryTextLabel.text = "The year is 1692. Amidst the horrible witch-trials that stalks the land you are an interrogator, tasked with hearing the confessions of those accused of being a witch. Your job is to interview and deem whether the accused is a witch and should be sent to the pyre or if she is innocent and should be spared.\n\nThis story starts as you arrive at the village of Whistlebrooke where the village elders has sent for you. The villagers have managed to capture and hold an alleged witch and are eagerly waiting for you to confirm what they already know. With nothing but your trusted notebook in hand you head for the old mine that the village now use as a temporary jail cell for witches."
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

        
    // Enable the start button when the player has added a name.
    @IBAction func playerNameTextFieldWasSelected(_ sender: Any) {

        playerNameTextField.text = nil
        startStoryButton.alpha = 1
        startStoryButton.isUserInteractionEnabled = true
        startStoryButton.setTitleColor(UIColor.red, for: .normal)
    }
    
    // Warn the user if no name was entered.
    func noNameEnteredWarning() {
        let warning = UIAlertController(title: "No name entered!", message: "Please enter your character's name.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        warning.addAction(cancelAction)
        present(warning, animated: true)
    }
    
    @IBAction func startNewStory(_ sender: Any) {
        if playerNameTextField.text != "" {
            guard let playerName = playerNameTextField.text else {return}
            newStory = Story(playerName: playerName)
            if let name = newStory.player?.name{
                print(name)
            }
            performSegue(withIdentifier: storySegueID, sender: Any?.self)
        } else { noNameEnteredWarning() }
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == storySegueID {
            let destinationVC = segue.destination as! StoryViewController
            destinationVC.myStory = newStory
        }
    }
}
