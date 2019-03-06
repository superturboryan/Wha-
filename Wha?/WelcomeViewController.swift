//
//  ViewController.swift
//  Wha?
//
//  Created by Ryan David Forsyth on 2019-03-05.
//  Copyright © 2019 Ryan F. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    //MARK: - IBOutlets and variables
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UI Updates
        messageTextView.layer.cornerRadius = CGFloat(7)
    }

    
    //MARK: - Buttons
    
    @IBAction func getStartedPressed(_ sender: UIButton) {
        
        performSegue(withIdentifier: "goToScanner", sender: nil)
    }
    

}

