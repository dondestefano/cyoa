//
//  NewStoryViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-02-13.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class NewGameViewController: UIViewController {
    
    var myStory = Story()
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
        startStoryButton.alpha = 1
        startStoryButton.setTitleColor(UIColor(red: 100, green: 0 , blue: 0, alpha: 0), for: .normal)
        startStoryButton.isUserInteractionEnabled = true
    }
    @IBAction func startNewStory(_ sender: Any) {
        let playerName = playerNameTextField.text
        myStory = Story(playerName: playerName ?? "Stranger")
        performSegue(withIdentifier: storySegueID, sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == storySegueID {
            let destinationVC = segue.destination as! MyStoryViewController
            destinationVC.myStory = myStory
        }
    }
}
