//
//  PopUpMenuViewController.swift
//  CYOA
//
//  Created by Michael De Stefano on 2020-02-16.
//  Copyright © 2020 Michael De Stefano. All rights reserved.
//

import UIKit

class PopUpMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.appearAnimation()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)

        // Do any additional setup after loading the view.
    }

    @IBAction func closePopUp(_ sender: Any) {
        self.removeAnimation()
    }
    
    @IBAction func goToMyStory(_ sender: Any) {
        self.removeAnimation()
        parent?.performSegue(withIdentifier: "segueToMyStory", sender: Any?.self)
    }
    
    @IBAction func goToMainMenu(_ sender: Any) {
        self.removeAnimation()
        parent?.performSegue(withIdentifier: "unwindSegue", sender: Any?.self)
    }
    
    // Close the pop-up if the user presses anything but a buttons.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let _: UITouch? = touches.first
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
    
//* Animations *//
    func appearAnimation() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimation() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0}, completion:{(finished : Bool) in
                if finished {
                    self.view.removeFromSuperview()
                }
        })
    }
}
