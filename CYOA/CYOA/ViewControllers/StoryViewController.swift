//
//  StoryViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

class StoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var myStory = Story()
    var currentOption : Option?
    let audio = AudioPlayer()
    let optionID = "optionsCellID"
    let myStorySegueID = "segueToMyStory"
    
    
    @IBOutlet weak var storyText: UITextView!
    @IBOutlet weak var chapterLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    @IBOutlet weak var choiceButton: UIButton!
    
    override func viewDidLoad() {
        // Read path and currentChapter from DB
        self.myStory.readPathFromDB()
        // Load chapter one if the current chapter is zero.
        // Otherwise just refresh.
        if myStory.currentChapter.chapterNumber == 0 {
            self.myStory.nextChapter{ self.refresh() }
        } else {self.myStory.readOptionsFromDB {self.refresh()}}
        
        super.viewDidLoad()
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.backgroundColor = .clear
        // Do any additional setup after loading the view
    }

//* TableView functions *//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myStory.availableOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionID, for: indexPath)
        let option = myStory.availableOptions[indexPath.row]
        cell.textLabel?.text = option.name
        if option.vitalChoice == "YouMonster" || option.vitalChoice == "FreeHer" || option.vitalChoice == "BurnHer" {
            cell.textLabel?.textColor = .red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = myStory.availableOptions[indexPath.row]
        currentOption = option
        choiceButton.isUserInteractionEnabled = true
        choiceButton.alpha = 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        UIView.animate(withDuration: 2, delay: 0.8 * Double(indexPath.row), animations: {cell.alpha = 1})
    }
    
//* Update functions *//
    func updateStoryText() {
        guard let currentStoryText = myStory.currentChapter.chapterText else {return}
        storyText.text = currentStoryText
    }
    
    func updateChapterLabel() {
        chapterLabel.text = "Chapter \(myStory.currentChapter.chapterNumber )"
    }
    
    func refresh() {
        hideStoryText()
        // Reset current option
        currentOption = nil
        // Disable the choice button
        choiceButton.isUserInteractionEnabled = false
        choiceButton.alpha = 0.4
        // Scroll the text back to the top
        storyText.setContentOffset(.zero, animated: true)
    }
    
//* Actions *//
    @IBAction func makeChoice(_ sender: UIButton) {
        guard let choice = currentOption else {return}
        myStory.pathChosen(choice: choice) {self.refresh()}
    }
    
    
//* Animations *//
    func hideStoryText(){
        // Hide the storys text and load the reveal function.
        UIView.animate(withDuration: 0.5, animations: {self.storyText.alpha = 0.0}, completion: revealNextChapter(finished:))
    }
    
    func revealNextChapter(finished: Bool){
        audio.playSound(sound: "new_page.mp3")
        updateChapterLabel()
        updateStoryText()
        UIView.animate(withDuration: 1.5, animations: {self.storyText.alpha = 1.0})
        optionsTableView.reloadData()
    }
    
    
    @IBAction func showPopUpMenu(_ sender: Any) {
        let popUpMenuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "popUpStoryBoardID")
        self.addChild(popUpMenuVC)
        popUpMenuVC.view.frame = self.view.frame
        self.view.addSubview(popUpMenuVC.view)
        popUpMenuVC.didMove(toParent: self)
    }
    
    //* Segues *//
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == myStorySegueID {
            let destinationVC = segue.destination as! MyStoryViewController
            destinationVC.myStory = myStory
        }
    }
}
