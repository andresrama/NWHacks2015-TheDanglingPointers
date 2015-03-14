//
//  API.swift
//  CarO2
//
//  Created by Ming Tang on 2015-03-14.
//  Copyright (c) 2015 Andres Rama. All rights reserved.
//

import Foundation

func createSession() -> NSURLSession {
    let sess = NSURLSession.sharedSession()
    return sess
}

func fetch(session: NSURLSession, url: NSString) {
    let nsurl = NSURL(string: url)!
    let task = session.dataTaskWithURL(nsurl) {(data, resp, err) in

 
    }
    task.resume()
}

func parseJSON(inputData: NSData) -> NSDictionary {
    var error: NSError?
    var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary

    return boardsDictionary
}
