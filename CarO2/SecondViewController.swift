//
//  SecondViewController.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var graphView: CPTGraphHostingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // create graph
        var graph = CPTXYGraph(frame: CGRectZero)
        graph.title = "Hello Graph"
        graph.paddingLeft = 0
        graph.paddingTop = 0
        graph.paddingRight = 0
        graph.paddingBottom = 0
        // hide the axes
        var axes = graph.axisSet as CPTXYAxisSet
        var lineStyle = CPTMutableLineStyle()
        lineStyle.lineWidth = 0
        axes.xAxis.axisLineStyle = lineStyle
        axes.yAxis.axisLineStyle = lineStyle
        
        // add a pie plot
        var pie = CPTPieChart(frame: self.view.frame)
        //pie.dataSource =
        pie.pieRadius = (self.view.frame.size.width * 0.9)/2
        graph.addPlot(pie)
        
        self.graphView.hostedGraph = graph
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

