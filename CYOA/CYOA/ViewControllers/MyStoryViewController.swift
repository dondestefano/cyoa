//
//  MyStoryViewController.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-02-03.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class MyStoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var myStory = Story()
    let storyCellID = "myStoryCellID"
    
    @IBOutlet weak var myStoryTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myStory.path.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: storyCellID, for: indexPath) as! MyStoryCell
        
        cell.chapterTextLabel.text = "Chapter \(myStory.path[indexPath.row].chapterNumber)"
        cell.storyTextLabel.text = myStory.path[indexPath.row].chapterText
        
        return cell
        
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let nib = UINib(nibName: "MyStoryCell", bundle: nil)
        
        myStoryTableView.register(nib, forCellReuseIdentifier: storyCellID)
        
        myStoryTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
}
