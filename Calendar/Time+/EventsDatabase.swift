//
//  EventsDatabase.swift
//  Time+
//
//  Created by Abdulhalim Rafeik on 1/24/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit
import SQLite
import Foundation

class EventsDatabase {
    enum EventRepeate: Int64{
        case none = 0, daily, weekely
    }
    
    /*typealias Event = (id: Int64,
                        startTime: Date,
                        endTime: Date,
                        date: Date,
                        repeate: Int64,
                        icon: String,
                        image: String,
                        notification: Int64)*/
    
    let db : Connection
    let eventsTable = Table("events")
    let columns = (id: Expression<Int64>("id"),
                   startTime: Expression<Date>("startTime"),
                   endTime: Expression<Date>("endTime"),
                   date: Expression<Date>("date"),
                   repeate: Expression<Int64>("repeate"),
                   icon: Expression<String>("icon"),
                   image: Expression<String>("image"),
                   notification: Expression<Int64>("notification"))
                   
                   
    
    let dataBasePath =  "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3"
    
    static let sharedInstance = EventsDatabase()
    
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    private init(){
        do{
            db = try Connection(dataBasePath)
            try db.run(eventsTable.create(ifNotExists: true) { t in
                t.column(columns.id, primaryKey: .autoincrement)
                t.column(columns.startTime)
                t.column(columns.endTime)
                t.column(columns.date)
                t.column(columns.repeate,
                         check: EventRepeate.none.rawValue...EventRepeate.weekely.rawValue ~= columns.repeate
                )
                t.column(columns.icon)
                t.column(columns.image)
                t.column(columns.notification)
            })
            
        } catch Result.error(let message, let code, let statment){
            fatalError("\(message) error code: \(code)")
        } catch {
            fatalError("unknown error opening database")
        }
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"

        timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        timeFormatter.dateFormat = "HH:mm"
        
        // test
        let insert = eventsTable.insert(
            columns.startTime <- timeFormatter.date(from: "14:15")!,
            columns.endTime <- timeFormatter.date(from: "14:30")!,
            columns.date <- dateFormatter.date(from: "2020-Jan-05")!,
            columns.repeate <- EventRepeate.none.rawValue,
            columns.icon <- " ",
            columns.image <- " ",
            columns.notification <- 0)
        do{
            try db.run(insert)
        }catch{
            fatalError("could not insert")

        }


    }
    
     
   public func getEvents(time: String, date: String) throws -> [Row]{
        let time = timeFormatter.date(from: time)
        let date = dateFormatter.date(from: date)
        
        let query = eventsTable.filter(columns.startTime <= time! && columns.endTime >= time! && columns.date == date!)
        
        return Array(try db.prepare(query))
    }
    
}
