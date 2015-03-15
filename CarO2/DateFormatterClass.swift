//
//  DateFormatterClass.swift
//  CarO2
//
//  Created by Apple on 3/15/15.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import Foundation
import UIKit

class DateFormatterClass: NSFormatter {
    
    var min : NSTimeInterval = 0;
    
    func prep(m:NSTimeInterval) {
        self.min = m
    }
    
    override func stringForObjectValue(obj: AnyObject) -> String? {
        var time = obj as NSTimeInterval
        var interval = NSTimeInterval(time + self.min)
        var date : NSDate = NSDate(timeIntervalSince1970: interval)
        var formatter : NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.stringFromDate(date)
    }
    
    override func getObjectValue(obj: AutoreleasingUnsafeMutablePointer<AnyObject?>, forString string: String, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>) -> Bool {
        return true
    }
}