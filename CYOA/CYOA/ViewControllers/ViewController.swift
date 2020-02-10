//
//  ViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit
import Firebase;

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var myStory = Story(playerName: "Michael")
    var currentOption : Option?
    let optionID = "optionsCellID"
    let myStorySegueID = "segueToMyStory"
    
    
    @IBOutlet weak var storyText: UITextView!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var choiceButton: UIButton!
    
    override func viewDidLoad() {
        self.myStory.nextChapter { self.refresh() }
        super.viewDidLoad()
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        // Do any additional setup after loading the view

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myStory.availableOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionID, for: indexPath)
        let option = myStory.availableOptions[indexPath.row]
        cell.textLabel?.text = option.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = myStory.availableOptions[indexPath.row]
        currentOption = option
        choiceButton.isUserInteractionEnabled = true
        choiceButton.alpha = 1
    }
    
    // Update functions //
    func updateStoryText() {
        guard let currentStoryText = myStory.currentChapter.chapterText else {return}
        storyText.text = currentStoryText
    }
    
    func updateChapterLabel() {
        chapterLabel.text = "Chapter \(myStory.currentChapter.chapterNumber )"
    }
    
    func refresh() {
        hideStoryText()
        optionsTableView.reloadData()
        currentOption = nil
        choiceButton.isUserInteractionEnabled = false
        choiceButton.alpha = 0.4
    }
    
    // Actions //
    @IBAction func makeChoice(_ sender: UIButton) {
        guard let choice = currentOption else {return}
        myStory.pathChosen(choice: choice) {self.refresh()}
    }
    
    
    // Animations //
    func hideStoryText(){
        UIView.animate(withDuration: 0.8, animations: {self.storyText.alpha = 0.0}, completion: revealNextChapter(finished:))
    }
    
    func revealNextChapter(finished: Bool){
        updateChapterLabel()
        updateStoryText()
        UIView.animate(withDuration: 1.5, animations: {self.storyText.alpha = 1.0})
    }
    
    // Segues //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == myStorySegueID {
            let destinationVC = segue.destination as! MyStoryViewController
            destinationVC.myStory = myStory
        }
    }
}
