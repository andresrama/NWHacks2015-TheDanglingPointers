//
//  ThirdViewController.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    var mojio : MojioClient?
    
    var graphing : Graphing?
    
    //Graph item thing
    var graph = CPTXYGraph(frame: CGRectZero)
    
    
    @IBOutlet weak var absorptionTime: UILabel!
    @IBOutlet weak var gggggg: CPTGraphHostingView!
    @IBOutlet weak var avgL: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mojio = MojioClient.client() as? MojioClient
        
        self.graphing = Graphing(
            mojio: self.mojio!,
            graph: self.graph,
            graphView: self.gggggg,
            view: view,
            fuelEff: false,
            limit: 600)
        self.graphing!.regraph(onRegraph)
        self.graphing!.getEvents(onRegraph)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onRegraph() {
        let graphing = self.graphing!
        
        var numFormatter : NSNumberFormatter = NSNumberFormatter()
        numFormatter.maximumFractionDigits = 1

        
        if let average = (numFormatter.stringFromNumber(graphing.co2Avg)) {
            avgL.text = average
        }
        
        if let absorption = (numFormatter.stringFromNumber(
            graphing.co2Avg * Double(graphing.tt) * 3600.0 * 1e-3 / 21.7724)) {
                absorptionTime.text = absorption
        }

    }

}


