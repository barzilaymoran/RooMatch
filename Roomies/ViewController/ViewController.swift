//
//  ViewController.swift
//  Roomies
//
//  Created by Studio on 23/12/2019.
//  Copyright © 2019 Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appTitle: UILabel!
    
    @IBOutlet weak var signInBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpBtn.layer.cornerRadius = 5
        signInBtn.layer.cornerRadius = 5
    }
}

