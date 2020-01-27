//
//  Time_Tests.swift
//  Time+Tests
//
//  Created by LibLabs-Mac on 11/28/19.
//  Copyright © 2019 LibLabs-Mac. All rights reserved.
//

import XCTest
@testable import Time_

class Time_Tests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() {
        jgrkgjjk
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        timeFormatter.dateFormat = "HH:mm"
        
        EventsDatabase.sharedInstance.enterEvent(startTime: "15:00", endTime: "16:00", date: "2020-Jan-15", iconPath: "yoMama", imagePath: "yoAunti")
        EventsDatabase.sharedInstance.enterEvent(startTime: "15:10", endTime: "16:00", date: "2020-Jan-15", repeate: .daily, iconPath: "yoMama", imagePath: "yoAunti" )

        for event in EventsDatabase.sharedInstance.getEvents(startTime: "14:20", endTime: "16:00", date: "2020-Jan-15"){
            print("start Time is \(timeFormatter.string(from: event[EventsDatabase.sharedInstance.columns.startTime])) , End time is \(timeFormatter.string(from: event[EventsDatabase.sharedInstance.columns.endTime])) Date is \(event[EventsDatabase.sharedInstance.columns.date]), icon path is \(event[EventsDatabase.sharedInstance.columns.icon]), repeate is  \(event[EventsDatabase.sharedInstance.columns.repeate])")
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
