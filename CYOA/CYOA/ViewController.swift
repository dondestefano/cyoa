//
//  ViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var myStory = Story(playerName: "Michael")
    var currentOption : Option?
    let optionID = "optionsCellID"
    
    @IBOutlet weak var storyText: UITextView!
    
    @IBOutlet weak var chapterLabel: UILabel!

    @IBOutlet weak var optionsTableView: UITableView!
    
    @IBAction func makeChoice(_ sender: UIButton) {
        guard let choice = currentOption else {return}
        myStory.pathChosen(choice: choice)
        print(myStory.player?.checkAttribute(attributeToCheck: choice.changedAttribute ?? "") ?? 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        // Do any additional setup after loading the view.
        
        guard let currentStoryText = myStory.currentChapter.chapterText else {return}
        storyText.text = currentStoryText
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myStory.currentChapter.chapterOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionID, for: indexPath)
        let option = myStory.currentChapter.chapterOptions[indexPath.row]
        cell.textLabel?.text = option.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = myStory.currentChapter.chapterOptions[indexPath.row]
        currentOption = option
        guard let chosenOption = currentOption else {return}
        print(chosenOption.name)
    }
    
}
