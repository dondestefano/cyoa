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
        

    @IBAction func playerNameTextFieldWasSelected(_ sender: Any) {
        playerNameTextField.text = nil
        startStoryButton.alpha = 1
        startStoryButton.isUserInteractionEnabled = true
    }
    
    
    @IBAction func startNewStory(_ sender: Any) {
        guard let playerName = playerNameTextField.text else {return}
        newStory = Story(playerName: playerName)
        if let name = newStory.player?.name{
            print(name)
        }
        performSegue(withIdentifier: storySegueID, sender: Any?.self)
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == storySegueID {
            let destinationVC = segue.destination as! ViewController
            destinationVC.myStory = newStory
        }
    }
}
