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
    
    var graphing : Graphing?
    
    //Graph item thing
    var graph = CPTXYGraph(frame: CGRectZero)
    
    //Graph item outlet
    @IBOutlet weak var graphView: CPTGraphHostingView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
        self.graphing = Graphing(
            mojio: self.mojio!,
            graph: self.graph,
            graphView: self.graphView,
            view: view,
            fuelEff: false)
        self.graphing!.regraph()
        self.graphing!.getEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TestButton(sender: AnyObject) {
        graph.reloadData()
    }

}

