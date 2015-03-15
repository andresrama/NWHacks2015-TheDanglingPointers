//
//  FirstViewController.swift
//  CarO2
//
//  Created by Apple on 3/13/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, CPTPlotDataSource {
    var mojio : MojioClient?
    
    //Graph item outlet
    
    @IBOutlet weak var graphView: CPTGraphHostingView!
    
    // Funcs to make the CPTPlotDataSource attribute true - Start
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        return 25
    }
    
    var maxHeight = 26
    var desiredMaxHeight = 10
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> NSNumber! {
        var rand = Float(arc4random_uniform(26))
        var mult = Float(desiredMaxHeight) / Float(maxHeight)
        var yResult = rand * mult
        switch(fieldEnum){
        case 0:
            return idx
        case 1:
            return yResult
        default:
            return 0
            
        }
    }
    //End
    
    //var gPreviousPlot : CPTScatterPlot?
    
    func plotGraph(graph : CPTXYGraph,
        dataSource : CPTPlotDataSource,
        tittle : String,
        xLineColor : CPTColor,
        xLineWidth : Float,
        yLineColor : CPTColor,
        yLineWidth : Float,
        xRangeLegnth : Float,
        yRangeLegnth : Float,
        dataLineColor : CPTColor,
        dataLineWidth : Float,
        paddingLeft : Int,
        paddingRight : Int,
        paddingTop : Int,
        paddingBottom : Int,
        backgroundColor : CGColor,
        previousPlot : CPTPlot?){
        
        graph.title = title
        graph.paddingLeft = CGFloat(paddingLeft)
        graph.paddingRight = CGFloat(paddingLeft)
        graph.paddingTop = CGFloat(paddingLeft)
        graph.paddingBottom = CGFloat(paddingLeft)
        
        //Axes Line Style
        var axes = graph.axisSet as CPTXYAxisSet
        
        var xLineStyle = CPTMutableLineStyle()
        xLineStyle.lineColor = xLineColor
        xLineStyle.lineWidth = CGFloat(xLineWidth)
        
        var yLineStyle = CPTMutableLineStyle()
        yLineStyle.lineColor = yLineColor
        yLineStyle.lineWidth = CGFloat(yLineWidth)
        
        axes.xAxis.axisLineStyle = xLineStyle
        axes.yAxis.axisLineStyle = yLineStyle
        
        var gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = CPTColor(componentRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.05)
        gridLineStyle.lineWidth = CGFloat(0.4)
        
        axes.yAxis.majorGridLineStyle = gridLineStyle
        
        //Axes properties
        var plotSpace = graph.defaultPlotSpace as CPTXYPlotSpace
        var xRange = plotSpace.xRange.mutableCopy() as CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        xRange.setLengthFloat(xRangeLegnth)
        yRange.setLengthFloat(yRangeLegnth)
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
        //Axes labels oh god why
        //axes.xAxis.la
        
        //Line settings
        var line = CPTScatterPlot(frame: view.frame)
        line.dataSource = dataSource
        line.backgroundColor = backgroundColor
        
        var dataLineStyle = CPTMutableLineStyle()
        dataLineStyle.lineColor = dataLineColor
        dataLineStyle.lineWidth = CGFloat(dataLineWidth)
        dataLineStyle.lineJoin = kCGLineJoinRound
        
        line.dataLineStyle = dataLineStyle
        line.alignsPointsToPixels = true
        
        //Finalize
        graph.addPlot(line)
        self.graphView.hostedGraph = graph
    }
    
    //Graph item thing
    var currentPlot = CPTXYGraph(frame: CGRectZero)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
        plotGraph(currentPlot,
            dataSource: self,
            tittle: "Function Plotted Line Graph",
            xLineColor: CPTColor(componentRed: 0, green: 0, blue: 255, alpha: 50),
            xLineWidth: 1,
            yLineColor: CPTColor(componentRed: 0, green: 0, blue: 255, alpha: 50),
            yLineWidth: 0,
            xRangeLegnth: 25,
            yRangeLegnth: 30,
            paddingLeft: 0,
            paddingRight: 0,
            paddingTop: 0,
            paddingBottom: 0,
            backgroundColor: CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 0, 0.0]),
            previousPlot: nil)
        
        getEvents()
    }
    
    //Graph item thing
    var graph = CPTXYGraph(frame: CGRectZero)
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TestButton(sender: AnyObject) {
        isUpdating = !isUpdating
        var color : CGColor
        if(isUpdating){
            color = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 255, 0, 0.01])
        }else{
            color = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0, 0, 255, 0.01])
        }
        currentPlot.reloadData()
    }

    func getEvents() {
        func success(data : AnyObject!) {
            println("Success")
            println(data)
            let arr = data as [AnyObject]
            println(arr.count)
            for item in arr {
                println(item)
            }
        }
        
        func failure(err : NSError!) {
            println("Failure")
            println(err)
        }
        
        let mojio = self.mojio!
        if (mojio.isUserLoggedIn()) {
            let queryOptions = [
                "limit": 10,
                "offset": 0,
                "desc": "true"
            ]
            
            mojio.getEntityWithPath("Events", withQueryOptions: queryOptions, success: success, failure: failure)
        }
    }
}

