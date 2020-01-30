//
//  ViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-01-25.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource  {
    
    var myStory = Story(playerName: "Michael")
    let optionID = "optionsCellID"
    
    @IBOutlet weak var storyText: UITextView!
    
    @IBOutlet weak var chapterLabel: UILabel!

    @IBOutlet weak var optionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionsTableView.dataSource = self
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
}
