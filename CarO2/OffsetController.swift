//
//  OffsetController.swift
//  CarO2
//
//  Created by Mark Leyfman on 3/14/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class OffsetController: UIViewController {
    
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBAction func finish(sender: AnyObject) {
        textField.resignFirstResponder()
        textField.enabled = false;
        textField.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewDidAppear(true)
        textField.becomeFirstResponder()
        finishButton.layer.cornerRadius = 10
    }
}
