//
//  SecondViewController.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, CPTPlotDataSource {
    
    //Graph item outlet
    @IBOutlet weak var graphView: CPTGraphHostingView!
    
    var maxPlotHeight : Int = 40
    var trololol : Int = 0
    
    
    // Funcs to make the CPTPlotDataSource attribute true - Start
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return 100
    }
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> NSNumber! {
        var rand = Int(arc4random_uniform(26))
        switch(fieldEnum){
        case 0:
            return idx
        case 1:
            if( rand > maxPlotHeight ){
                maxPlotHeight = rand
                println(":\(rand)")
            }
            return rand
        default:
            return 0
            
        }
    }
    //End
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // create graph
        var graph = CPTXYGraph(frame: CGRectZero)
        
        //Tittle
        graph.title = "Line Graph"
        
        //Padding
        graph.paddingLeft = 0
        graph.paddingTop = 0
        graph.paddingRight = 0
        graph.paddingBottom = 0
        
        //Axes set up...
        var axes = graph.axisSet as CPTXYAxisSet
        var lineStyle = CPTMutableLineStyle()
        lineStyle.lineColor = CPTColor(componentRed: 255, green: 0, blue: 0, alpha: 50)
        lineStyle.lineWidth = 1
        axes.xAxis.axisLineStyle = lineStyle
        axes.yAxis.axisLineStyle = lineStyle
        
        var plotSpace = graph.defaultPlotSpace as CPTXYPlotSpace
        var xRange = plotSpace.xRange.mutableCopy() as CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        xRange.setLengthFloat(100)
        
        var line = CPTScatterPlot(frame: view.frame)
        line.dataSource = self
        line.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 0, 0.01])
        let maxFloat = Float(maxPlotHeight)
        println("-------------------------------HEIGHT: \(maxFloat)")
        yRange.setLengthFloat(maxFloat)
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
        graph.addPlot(line)
        
        self.graphView.hostedGraph = graph
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

