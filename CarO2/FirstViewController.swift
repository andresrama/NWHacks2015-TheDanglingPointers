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
    @IBOutlet weak var averageFE: UILabel!
    @IBOutlet weak var worstFE: UILabel!
    @IBOutlet weak var bestFE: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
        self.graphing = Graphing(
            mojio: self.mojio!,
            graph: self.graph,
            graphView: self.graphView,
            view: view,
            fuelEff: true)
        self.graphing!.regraph(onRegraph)
        self.graphing!.getEvents(onRegraph)
    }
    
    func onRegraph() {
        let graphing = self.graphing!
        
        var numFormatter : NSNumberFormatter = NSNumberFormatter()
        numFormatter.maximumFractionDigits = 1
        if let best = (numFormatter.stringFromNumber(graphing.effMin)){
            bestFE.text = best
        }
        if let worst = (numFormatter.stringFromNumber(graphing.effMax)){
            worstFE.text = worst
        }
        
        if let average = (numFormatter.stringFromNumber(graphing.effAvg)) {
            averageFE.text = average
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TestButton(sender: AnyObject) {
        graph.reloadData()
    }

}

