//
//  SecondViewController.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    var mojio : MojioClient?
    
    var fuelGr : Graphing?
    var co2Gr : Graphing?
    
    var fuelGraph = CPTXYGraph(frame: CGRectZero)
    var co2Graph = CPTXYGraph(frame: CGRectZero)
    
    @IBOutlet weak var offsetButton: UIButton!
    @IBOutlet weak var fuelGH: CPTGraphHostingView!
    @IBOutlet weak var co2GH: CPTGraphHostingView!
    
    @IBOutlet weak var bestL: UILabel!
    @IBOutlet weak var worstL: UILabel!
    @IBOutlet weak var avgL: UILabel!
    @IBOutlet weak var avgCO2L: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        offsetButton.layer.cornerRadius = 10
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
        self.fuelGr = Graphing(
            mojio: self.mojio!,
            graph: self.fuelGraph,
            graphView: self.fuelGH,
            view: view,
            fuelEff: true,
            limit: 100)
        self.fuelGr!.regraph(gggfff)
        self.fuelGr!.getEvents(gggfff)
        
        self.co2Gr = Graphing(
            mojio: self.mojio!,
            graph: self.co2Graph,
            graphView: self.co2GH,
            view: view,
            fuelEff: false,
            limit: 100)
        self.co2Gr!.regraph(gggccc)
        self.co2Gr!.getEvents(gggccc)
    }
    
    func gggfff() {
        let fuelGr = self.fuelGr!
        
        var numFormatter : NSNumberFormatter = NSNumberFormatter()
        numFormatter.maximumFractionDigits = 1
        if let best = (numFormatter.stringFromNumber(fuelGr.effMin)){
            bestL.text = best
        }
        if let worst = (numFormatter.stringFromNumber(fuelGr.effMax)){
            worstL.text = worst
        }
        
        if let average = (numFormatter.stringFromNumber(fuelGr.effAvg)) {
            avgL.text = average
        }
    }
    
    func gggccc() {
        let co2Gr = self.co2Gr!
        
        var numFormatter : NSNumberFormatter = NSNumberFormatter()
        numFormatter.maximumFractionDigits = 1
        
        if let average = (numFormatter.stringFromNumber(co2Gr.co2Avg)) {
            avgCO2L.text = average
        }
    }
}

