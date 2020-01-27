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
    let scenarioTracker = ScenarioTracker()
    
    @IBOutlet weak var storyText: UITextView!
    
    @IBOutlet weak var optionOneButton: UIButton!
    
    @IBOutlet weak var optionTwoButton: UIButton!
    
    override func viewDidLoad() {
        scenarioTracker.possibleStory.createScenarios()
        super.viewDidLoad()
        currentScenario = scenarioTracker.newStory()
        nextPage()
        
        
        // Do any additional setup after loading the view.
    }

    @IBAction func pressedButtonOne(_ sender: Any) {
        choosePath(path: 1)
    }
    
    @IBAction func pressedButtonTwo(_ sender: Any) {
        choosePath(path: 2)
    }
    
    func nextPage() {
        let currentParagraph = currentScenario.getParagraph()
        storyText.text = currentParagraph
        optionOneButton.setTitle("\(currentScenario.optionOne ?? "")", for: .normal)
        optionTwoButton.setTitle("\(currentScenario.optionTwo ?? "")", for: .normal)
    }
    
    func choosePath(path: Int) {
        scenarioTracker.calculateNextScenario(chosenPathValue: path)
        currentScenario = scenarioTracker.story[scenarioTracker.currentScenarioIndex]
        nextPage()
    }
}
