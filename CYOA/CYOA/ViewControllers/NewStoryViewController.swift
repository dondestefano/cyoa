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
        newStoryTextLabel.text = "Welcome to the new story.\n\nPlease enter your name"
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
            let destinationVC = segue.destination as! ViewController
            destinationVC.myStory = newStory
        }
    }
}
