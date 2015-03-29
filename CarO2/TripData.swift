//
//  TripData.swift
//  CarO2
//
//  Created by Ming Tang on 2015-03-28.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import Foundation

class TripData : NSObject {
    var mojio : MojioClient
    var fuelEff : Bool
    var limit : Int

    init(mojio: MojioClient, fuelEff: Bool, limit:Int) {
        self.mojio = mojio
        self.fuelEff = fuelEff
        self.limit = limit
    }
    
    
    // datetime, deltaCO2, fuelEfficiency
    var eventsArray : [(NSDate, Double, Double)]? = nil
    
    var effAvg : Double = 0.0
    var effMax : Double = 0.0
    var effMin : Double = 100.0
    
    var co2Avg : Double = 0.0
    var co2Max : Double = 0.0
    var co2Min : Double = 100.0
    
    var nn : Double = 1.0
    var tt : Double = 1.0
    
    
    var timeMax : NSDate = NSDate(timeIntervalSince1970: 0)
    var timeMin : NSDate = NSDate(timeInterval: 1000, sinceDate: NSDate())
    
    let formatter: NSDateFormatter = NSDateFormatter()
    
    func makeDate(dateStr: String) -> NSDate {
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter.dateFromString(dateStr)!
        
    }
    
    func getEvents(onRegraph: (() -> Void)?) {
        
        let mojio = self.mojio
        if (mojio.isUserLoggedIn()) {
            let queryOptions = [
                "limit": self.limit,
                "offset": 0,
            ]
            
            mojio.getEntityWithPath("Trips", withQueryOptions: queryOptions, success: {
                (data : AnyObject!) in
                let arrTrips = data as [Trip]
                let latestTrip = arrTrips[arrTrips.count - 1]
                
                let queryOptions = [
                    "limit": self.limit,
                    "offset": 0,
                    "id": latestTrip._id
                ]
                mojio.getEntityWithPath("Trips/\(latestTrip._id)/Events", withQueryOptions: queryOptions, success: {
                    (data : AnyObject!) in
                    let result = data as [Event]
                    // Generate a set of XY values
                    
                    var prevDist:Double = 0.0
                    
                    let pairs: [(NSDate, Double, Double)] = Array(map(1..<result.count - 1) {
                        (i: Int) in
                        let cur: Event = result[i]
                        let prv: Event = result[i - 1]
                        let d = self.makeDate(cur.Time);
                        let prevd = self.makeDate(prv.Time);
                        
                        let distance = prevDist + Double(cur.Speed) * (d.timeIntervalSinceDate(prevd))/(60.0*60.0)
                        let deltaFuel = distance * Double(cur.FuelEfficiency) - prevDist * Double(prv.FuelEfficiency)
                        let deltaCO2 = max(0.0, 1e3 * (deltaFuel * 2.3035e-1) / (d.timeIntervalSinceDate(prevd)*1e3))
                        let totalCO2 = distance * Double(cur.FuelEfficiency) * 2.3035
                        
                        prevDist = distance;
                        
                        if ( d.compare(self.timeMax)) == NSComparisonResult.OrderedDescending{
                            self.timeMax = d
                            println(self.timeMax)
                        }
                        if (d.compare(self.timeMin)) == NSComparisonResult.OrderedAscending{
                            self.timeMin = d
                            println(self.timeMin)
                        }
                        
                        return (d, deltaCO2, Double(cur.FuelEfficiency));
                        
                        })
                    
                    
                    
                    self.eventsArray = pairs;
                    
                    let nnn = Double(pairs.count)
                    let ttt = Double(self.timeMax.timeIntervalSince1970 - self.timeMin.timeIntervalSince1970) / (3600.0)
                    self.tt = ttt
                    self.nn = nnn
                    self.effMin = self.eventsArray!.map({ $0.2 }).reduce(Double.infinity, { min($0, $1) })
                    self.effMax = self.eventsArray!.map({ $0.2 }).reduce(-Double.infinity, { max($0, $1) })
                    self.effAvg = self.eventsArray!.map({ $0.2 }).reduce(0.0, +) / nnn
                    
                    self.co2Min = self.eventsArray!.map({ $0.1 }).reduce(Double.infinity, { min($0, $1) })
                    self.co2Max = self.eventsArray!.map({ $0.1 }).reduce(-Double.infinity, { max($0, $1) })
                    self.co2Avg = self.eventsArray!.map({ $0.1 }).reduce(0.0, +) / ttt
                    
                    println("e=(\(self.effMin), \(self.effMax), \(self.effAvg))")
                    println("c=(\(self.co2Min), \(self.co2Max), \(self.co2Avg))")
                    
                    
                    onRegraph?()
                    println(pairs);
                    }, failure: self.handleFailure)
                }, failure: self.handleFailure)
            
        }
        
        //let timeout = dispatch_time(DISPATCH_TIME_NOW, 100000000000)
        //print("Wait outcome:")
        //println(dispatch_semaphore_wait(ss, timeout))
        //print("eventsArray == nil ?")
        //println(eventsArray == nil)
    }
    
    
    func handleFailure(err : NSError!) {
        println("Failure")
        println(err)
    }

}