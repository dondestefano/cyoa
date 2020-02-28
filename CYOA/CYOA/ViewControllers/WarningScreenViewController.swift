//
//  WarningScreenViewController.swift
//  CYOA
//
//  Created by Michael De Stefano on 2020-02-26.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class WarningScreenViewController: UIViewController {
    
    var myStory = Story()
    let newStorySegueID = "segueFromWarningScreenToNewStory"
    let returnID = "segueFromWarningScreenToNewStory"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func continueToNewStory(_ sender: Any) {
        self.performSegue(withIdentifier: newStorySegueID, sender: Any?.self)
    }
    
    @IBAction func quitToMainMenu(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindSegue", sender: Any?.self)
    }
    
    //* Segues *//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == newStorySegueID {
            let destinationVC = segue.destination as! NewStoryViewController
            destinationVC.newStory = myStory
        }
    }
}
