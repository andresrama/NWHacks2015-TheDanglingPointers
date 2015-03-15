//
//  SecondViewController.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var offsetButton: UIButton!
   
    override func viewDidAppear(animated: Bool) {
        offsetButton.layer.cornerRadius = 10
    }
}

