//
//  FirstViewController.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    var mojio : MojioClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func logInClicked(sender: AnyObject) {
        println("Login Clicked")
        let mojio = self.mojio!
        
        
        println("Mojio is initialized", mojio)
    }

    @IBAction func testAPICallClicked(sender: AnyObject) {
        println("Test API Call Clicked")
        let mojio = self.mojio!
        
        if (mojio.isUserLoggedIn()) {

            var queryOptions = [
                "limit": 1,
                "offset": 0,
                "sortBy": "LastContactTime",
                "desc": "true"
            ]
            mojio.getEntityWithPath("Vehicles", withQueryOptions: queryOptions,
                success: { (obj: AnyObject!) in
                    println("Success: ", obj)
                }, failure: { (err: NSError!) in
                    println("Failure: ", err)
            })
        } else {
            println("---Not Logged In---")
        }
    }
}

