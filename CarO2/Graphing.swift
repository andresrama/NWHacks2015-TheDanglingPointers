//
//  Graphing.swift
//  CarO2
//
//  Created by Ming Tang on 2015-03-15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import Foundation

class Graphing : TripData, CPTPlotDataSource {
    let π = M_PI
    
    var graph : CPTXYGraph
    var view : UIView!
    var graphView : CPTGraphHostingView
    
    
    init(mojio:MojioClient, graph : CPTXYGraph, graphView: CPTGraphHostingView, view: UIView!, fuelEff: Bool, limit:Int) {
        self.graph = graph
        self.graphView = graphView
        self.view = view
        
        super.init(mojio: mojio, fuelEff: fuelEff, limit: limit)
    }
    
    
    // Funcs to make the CPTPlotDataSource attribute true - Start
    func numberOfRecordsForPlot(plot: CPTPlot!) -> UInt {
        if let aaa = eventsArray {
            let count = Float(aaa.count)/2.0
            return UInt(count)
        } else {
            return 0
        }
    }
    
    var desiredMaxHeight = 60
    
    func numberForPlot(plot: CPTPlot!, field fieldEnum: UInt, recordIndex idx: UInt) -> NSNumber! {
        switch(fieldEnum){
        case 0:
            if let aaa = eventsArray {
                let count = Float(aaa.count)
                let (date, dCO2, fe) = aaa[Int(idx)]
                
                return date.timeIntervalSince1970//.timeIntervalSinceDate(NSDate(timeIntervalSince1970: self.timeMin.timeIntervalSince1970))
            } else {
                return 0.0
            }
        case 1:
            if let aaa = eventsArray {
                if (fuelEff) {
                    // fuel efficiency
                    return aaa[Int(idx)].2
                } else {
                    // dCO2
                    return aaa[Int(idx)].1
                }
            } else {
                return 0.0
            }
        default:
            return 0
            
        }
    }
    //End
    
    func regraph(onRegraph: (() -> Void)?) {
        //Andys code. please no delete ty
        //My "Globals"
        var blue = CPTColor(componentRed: 0.0, green: 0.0, blue: 1.0, alpha: 0.5)
        var grey = CPTColor(componentRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.1)
        var green = CPTColor(componentRed: 0.3, green: 0.6, blue: 0.4, alpha: 1.0)
        
        graph.title = ""
        graph.plotAreaFrame.paddingTop = 5
        graph.plotAreaFrame.paddingBottom = 60
        graph.plotAreaFrame.paddingLeft = 10
        graph.plotAreaFrame.paddingRight = 5
        
        var axes = graph.axisSet as CPTXYAxisSet
        axes.xAxis.title = "Time"
        axes.yAxis.title = "L/100km"
        
        axes.yAxis.titleOffset = 30
        axes.xAxis.titleOffset = 35
        
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
        
        axes.xAxis.labelRotation = CGFloat(π/4.0)
        
        //axes.xAxis.majorTickLength = 50
        //axes.xAxis.minorTickLength = 10
        //axes.xAxis.majorTickLength = 10
        //axes.xAxis.minorTickLength = 10
        //axes.xAxis.minorTicksPerInterval = 1
        
        
        axes.xAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        axes.xAxis.preferredNumberOfMajorTicks = 10
        
        axes.yAxis.labelingPolicy = CPTAxisLabelingPolicy.Automatic
        axes.yAxis.preferredNumberOfMajorTicks = 5
        
        var numFormatter = NSNumberFormatter()
        numFormatter.formatWidth = 2
        
        //dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        //dateFormatter.dateFormat = "hh:mm dd/MM/yy"
        var hackyPOS  = DateFormatterClass()
        hackyPOS.prep(self.timeMin.timeIntervalSince1970)
        axes.xAxis.labelFormatter = hackyPOS
        axes.yAxis.labelFormatter = numFormatter
        
        var gridLineStyle = CPTMutableLineStyle()
        gridLineStyle.lineColor = grey
        gridLineStyle.lineWidth = CGFloat(0.4)
        
        axes.yAxis.majorGridLineStyle = gridLineStyle
        
        /*
        var plotSpace = graph.defaultPlotSpace as CPTXYPlotSpace
        
        var xRange = plotSpace.xRange.mutableCopy() as CPTMutablePlotRange
        var yRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        xRange.minLimitDouble =
        xRange.setLengthFloat(Float(Int(timeMax-timeMin)))
        yRange.setLengthFloat(Float(max))
        
        plotSpace.xRange = xRange
        plotSpace.yRange = yRange*/
        
        
        var plotSpace = graph.defaultPlotSpace as CPTXYPlotSpace
        
        var gxr = plotSpace.xRange.mutableCopy() as CPTMutablePlotRange
        if let aaa = eventsArray {
            if (aaa.count > 80) {
                gxr.setLengthFloat(Float(aaa.count))
            }
        }
        //plotSpace.globalXRange = gxr
        
        //plotSpace.globalYRange = plotSpace.yRange.mutableCopy() as CPTMutablePlotRange
        
        //plotSpace.allowsMomentumX = true
        //plotSpace.allowsMomentumY = false
        plotSpace.allowsUserInteraction = false
        
        var line = CPTScatterPlot(frame: self.view.frame)
        
        var dataLineStyle = CPTMutableLineStyle()
        dataLineStyle.lineColor = green
        dataLineStyle.lineWidth = CGFloat(2.0)
        dataLineStyle.lineJoin = kCGLineJoinRound
        
        line.dataLineStyle = dataLineStyle
        line.alignsPointsToPixels = true
        
        line.dataSource = self
        graph.addPlot(line)
        graphView.hostedGraph = graph
        
        //You can put stuff after too. just dont fuck me k?
        graph.reloadData()
        
        
        
        graph.defaultPlotSpace.scaleToFitPlots(graph.allPlots())
        
        if let f = onRegraph {
            println("TOROLROELEOE")
            f()
        }
    }
    
    override func getEvents(onRegraph: (() -> Void)?) {
        super.getEvents {
            self.regraph(onRegraph)
        }
    }
}
