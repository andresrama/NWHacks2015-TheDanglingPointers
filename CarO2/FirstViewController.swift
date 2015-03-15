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
    
    let π = M_PI
    
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
    var graph = CPTXYGraph(frame: CGRectZero)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
        //Andys code. please no delete ty
        //My "Globals"
        var blue = CPTColor(componentRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        var grey = CPTColor(componentRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        var green = CPTColor(componentRed: 0.3, green: 0.6, blue: 0.4, alpha: 1.0)
        
        graph.title = "Tittle"
        graph.plotAreaFrame.paddingTop = 10
        graph.plotAreaFrame.paddingBottom = 50
        graph.plotAreaFrame.paddingLeft = 50
        graph.plotAreaFrame.paddingRight = 50
        
        var axes = graph.axisSet as CPTXYAxisSet
        axes.xAxis.title = "X-AXIS"
        axes.yAxis.title = "Y-AXIS"
        
        var xLineStyle = CPTMutableLineStyle()
        xLineStyle.lineColor = blue
        xLineStyle.lineWidth = CGFloat(1)
        
        var yLineStyle = CPTMutableLineStyle()
        yLineStyle.lineColor = green
        yLineStyle.lineWidth = CGFloat(0.7)
        
        axes.xAxis.axisLineStyle = xLineStyle
        axes.yAxis.axisLineStyle = yLineStyle
        
        axes.xAxis.labelRotation = CGFloat(π/2.0)
        
        var gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = grey
        gridLineStyle.lineWidth = CGFloat(0.4)
        
        axes.yAxis.majorGridLineStyle = gridLineStyle
        
        var plotSpace = graph.defaultPlotSpace as CPTXYPlotSpace
        var xRange = plotSpace.xRange.mutableCopy() as CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        xRange.setLengthFloat(25)
        yRange.setLengthFloat(10)
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        
        var line = CPTScatterPlot(frame: view.frame)
        
        var dataLineStyle = CPTMutableLineStyle()
        dataLineStyle.lineColor = green
        dataLineStyle.lineWidth = CGFloat(2.0)
        dataLineStyle.lineJoin = kCGLineJoinRound
        
        line.dataLineStyle = dataLineStyle
        line.alignsPointsToPixels = true
        
        line.dataSource = self
        graph.addPlot(line)
        self.graphView.hostedGraph = graph
        
        //You can put stuff after too. just dont fuck me k?
    
        getEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TestButton(sender: AnyObject) {
        graph.reloadData()
    }

    
    let formatter: NSDateFormatter = NSDateFormatter()
    
    func makeDate(dateStr: String) -> NSDate {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.dateFromString(dateStr)!

    }
    
    var eventsArray : [(NSDate, Float)]? = nil
    
    func getEvents() {
        let ss = dispatch_semaphore_create(0)
        
        func success(data : AnyObject!) {
            println("Success")
            //println(data)
            let arr = data as [Event]
            
            print("Items: ")
            println(arr.count)
            
            eventsArray = arr.map({ event in
                let dt: (NSDate, Float) = (self.makeDate(event.Time), event.FuelEfficiency)
                //println(dt)
                return dt
            })
            
            graph.reloadData()
            
            dispatch_semaphore_signal(ss)
        }
        
        func failure(err : NSError!) {
            println("Failure")
            println(err)
            dispatch_semaphore_signal(ss)
        }
        
        let mojio = self.mojio!
        if (mojio.isUserLoggedIn()) {
            let queryOptions = [
                "limit": 1000,
                "offset": 0,
                "desc": "true"
            ]
            
            mojio.getEntityWithPath("Events", withQueryOptions: queryOptions, success: success, failure: failure)
        }
        
        //let timeout = dispatch_time(DISPATCH_TIME_NOW, 100000000000)
        //print("Wait outcome:")
        //println(dispatch_semaphore_wait(ss, timeout))
        //print("eventsArray == nil ?")
        //println(eventsArray == nil)
    }
}

