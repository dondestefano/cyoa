//
//  ViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
//    var currentScenario = Scenario (act: 0, chapter: 0)
//    let scenarioTracker = ScenarioTracker()
    
    var myStory = Story(playerName: "Miche")
    
    @IBOutlet weak var storyText: UITextView!
    
    @IBOutlet weak var optionOneButton: UIButton!
    
    @IBOutlet weak var optionTwoButton: UIButton!
    
    override func viewDidLoad() {
        myStory.chapterOne()
//        scenarioTracker.possibleStory.createScenarios()
        super.viewDidLoad()
//        currentScenario = scenarioTracker.newStory()
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
        let currentParagraph = myStory.currentScenario.getParagraph()
        storyText.setContentOffset(.zero, animated: true)
        storyText.text = currentParagraph
        optionOneButton.setTitle("\(myStory.currentScenario.optionOne ?? "")", for: .normal)
        optionTwoButton.setTitle("\(myStory.currentScenario.optionTwo ?? "")", for: .normal)
    }
    
    func choosePath(path: Int) {
//        scenarioTracker.calculateNextScenario(chosenPathValue: path)
//        currentScenario = scenarioTracker.story[scenarioTracker.currentScenarioIndex]
        guard let chapter = myStory.currentScenario.chapter else {return}
        myStory.nextChapter(currentChapter: chapter, decision: path)
        storyText.setContentOffset(.zero, animated: false)
        nextPage()
    }
}
