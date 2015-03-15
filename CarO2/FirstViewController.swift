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
        if let aaa = eventsArray {
            return UInt(aaa.count)
        } else {
            return 0
        }
    }
    
    var desiredMaxHeight = 60
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> NSNumber! {
        switch(fieldEnum){
        case 0:
            return idx
        case 1:
            if let aaa = eventsArray {
                let (date, fe) = aaa[Int(idx)]
                return fe
            } else {
                return 0.0
            }
        default:
            return 0
            
        }
    }
    //End
    
    //Graph item thing
    var graph = CPTXYGraph(frame: CGRectZero)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mojio = MojioClient.client() as? MojioClient
        
        regraph()
        getEvents()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func TestButton(sender: AnyObject) {
        graph.reloadData()
    }

    func regraph() {
        //Andys code. please no delete ty
        //My "Globals"
        var blue = CPTColor(componentRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        var grey = CPTColor(componentRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        var green = CPTColor(componentRed: 0.3, green: 0.6, blue: 0.4, alpha: 1.0)
        
        graph.title = "Tittle"
        graph.plotAreaFrame.paddingTop = 5
        graph.plotAreaFrame.paddingBottom = 40
        graph.plotAreaFrame.paddingLeft = 60
        graph.plotAreaFrame.paddingRight = 5
        
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
        
        //axes.yAxis.majorTickLength = 50
        //axes.yAxis.minorTickLength = 10
        axes.yAxis.minorTicksPerInterval = 1
        
        axes.xAxis.labelRotation = CGFloat(π/2.0)
        //axes.xAxis.majorTickLength = 50
        //axes.xAxis.minorTickLength = 10
        axes.xAxis.majorTickLength = 10
        axes.xAxis.minorTickLength = 10
        axes.xAxis.minorTicksPerInterval = 1


        axes.xAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        axes.xAxis.preferredNumberOfMajorTicks = 10

        axes.yAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        axes.yAxis.preferredNumberOfMajorTicks = 5

        var gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = grey
        gridLineStyle.lineWidth = CGFloat(0.4)
        
        axes.yAxis.majorGridLineStyle = gridLineStyle
        
        var plotSpace = graph.defaultPlotSpace as CPTXYPlotSpace
        
        var xRange = plotSpace.xRange.mutableCopy() as CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        xRange.setLengthFloat(Float(80))
        yRange.setLengthFloat(Float(max))
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange
        var gxr = plotSpace.xRange.mutableCopy() as CPTMutablePlotRange
        if let aaa = eventsArray {
            if (aaa.count > 80) {
                gxr.setLengthFloat(Float(aaa.count))
            }
        }
        plotSpace.globalXRange = gxr
        
        plotSpace.globalYRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        
        plotSpace.allowsMomentumX = true
        plotSpace.allowsMomentumY = false
        plotSpace.allowsUserInteraction = true
        
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
        graph.reloadData()
    }
    
    let formatter: NSDateFormatter = NSDateFormatter()
    
    func makeDate(dateStr: String) -> NSDate {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.dateFromString(dateStr)!

    }
    
    var eventsArray : [(NSDate, Double)]? = nil
    var avg : Double = 0.0
    var max : Double = 100.0
    
    func getEvents() {
        let ss = dispatch_semaphore_create(0)
        
        func success(data : AnyObject!) {
            println("Success")
            //println(data)
            let arr = data as [Event]
            
            print("Items: ")
            println(arr.count)
            
            var ccc = 0
            var sss: Double = 0.0
            eventsArray = arr.map({ event in
                let fe = Double(event.FuelEfficiency)
                let dt: (NSDate, Double) = (self.makeDate(event.Time), fe)
                ccc++
                sss += fe
                if (fe > self.max) {
                    self.max = fe
                }
                //println(dt)
                return dt
            })
            
            self.avg = sss / Double(ccc)
            print("Avg: ")
            println(self.avg)
            print("Max: ")
            println(self.max)
            
            dispatch_semaphore_signal(ss)
            
            self.regraph()
        }
        
        func failure(err : NSError!) {
            println("Failure")
            println(err)
            dispatch_semaphore_signal(ss)
        }
        
        let mojio = self.mojio!
        if (mojio.isUserLoggedIn()) {
            let queryOptions = [
                "limit": 200,
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

