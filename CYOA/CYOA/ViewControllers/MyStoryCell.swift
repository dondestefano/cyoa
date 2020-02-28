//
//  MyStoryCell.swift
//  CYOA
//
//  Created by Luigi Anonymus on 2020-02-03.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class MyStoryCell: UITableViewCell {

    @IBOutlet weak var chapterTextLabel: UILabel!
    
    @IBOutlet weak var storyTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
