//
//  ViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var currentScenario = Scenario (act: 0, chapter: 0)
    
    @IBOutlet weak var storyText: UITextView!
    
    @IBOutlet weak var optionOneButton: UIButton!
    
    @IBOutlet weak var optionTwoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentScenario.nextScenario(act: 1, chapter: 1, paragraphOne: "Hej", paragraphTwo: "Vad", paragraphThree: "Händer", optionOne: "Inget", optionTwo: "massor")
        
        updateStory()
        
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func pressedButtonOne(_ sender: Any) {
        currentScenario.nextScenario(act: 1, chapter: 2, paragraphOne: "Låter", paragraphTwo: "Mega", paragraphThree: "Trist", optionOne: "K", optionTwo: "Bry")
        updateStory()
        
    }
    
    @IBAction func pressedButtonTwo(_ sender: Any) {
            currentScenario.nextScenario(act: 1, chapter: 2, paragraphOne: "Lol.", paragraphTwo: "Berätta", paragraphThree: "Mer", optionOne: "Nej", optionTwo: "Ok")
        updateStory()
    }
    
    func updateStory() {
        let currentParagraph = currentScenario.getParagraph()
        
        storyText.text = currentParagraph
        optionOneButton.setTitle("\(currentScenario.optionOne ?? "")", for: .normal)
        optionTwoButton.setTitle("\(currentScenario.optionTwo ?? "")", for: .normal)
    }
    
}
