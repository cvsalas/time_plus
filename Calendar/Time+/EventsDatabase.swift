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
                t.column(columns.repeate
                    /*, check: EventRepeate.none.rawValue...EventRepeate.weekely.rawValue ~= columns.repeate*/
                )
                t.column(columns.icon)
                t.column(columns.image)
                t.column(columns.notification)
            })
            
        } catch Result.error(let message, let code, let statment){
            fatalError("\(message) error code: \(code) statment: \(String(describing: statment))")
        } catch {
            fatalError("unknown error opening database")
        }
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        timeFormatter.dateFormat = "HH:mm"
    }
    
    func updateEvents(cond: Expression<Bool>,  startTime: String? = nil, endTime: String? = nil, date: String? = nil,
                      repeate: EventRepeate? = nil, iconPath: String? = nil, imagePath: String? = nil, notification: Int64? = nil){
        updateEvent(cond: cond,
                    startTime: startTime != nil ? timeFormatter.date(from: startTime!) : nil,
                    endTime: endTime != nil ? timeFormatter.date(from: endTime!) : nil,
                    date: date != nil ? dateFormatter.date(from: date!) : nil,
                    iconPath: iconPath, imagePath: imagePath)
    }
    
    
    func updateEvent(cond: Expression<Bool>, startTime: Date? = nil, endTime: Date? = nil, date: Date? = nil,
                     repeate: EventRepeate? = nil, iconPath: String? = nil, imagePath: String? = nil, notification: Int64? = nil) {
        
        let filterExpr = eventsTable.filter(cond)
        var setters : [Setter] = []
        
        if let val = startTime{
            setters.append(columns.startTime <- val)
        }
        
        if let val = endTime{
            setters.append(columns.endTime <- val)
        }
        
        if let val = date{
            setters.append(columns.date <- val)
        }
        
        if let val = repeate{
            setters.append(columns.repeate <- val.rawValue)
        }
        
        if let val = iconPath{
            setters.append(columns.icon <- val)
        }
        
        if let val = imagePath{
            setters.append(columns.image <- val)
        }
        
        if let val = notification{
            setters.append(columns.notification <- val)
        }
        
        do{
            try db.run(filterExpr.update(setters))
        } catch {
            fatalError("Could not update value")
        }
        
    }
    
    
    func enterEvent(startTime: String, endTime: String, date: String,
                    repeate: EventRepeate = .none, iconPath: String, imagePath: String, notification: Int64 = 0) {
        
        enterEvent(startTime: timeFormatter.date(from: startTime)!, endTime: timeFormatter.date(from: endTime)!,
                   date: dateFormatter.date(from: date)!, iconPath: iconPath, imagePath: imagePath)
    }
    
    func enterEvent(startTime: Date, endTime: Date, date: Date,
                    repeate: EventRepeate = .none, iconPath: String, imagePath: String, notification: Int64 = 0) {
        
        let insert = eventsTable.insert(
            columns.startTime <- startTime,
            columns.endTime <- endTime,
            columns.date <- date,
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
    
    func getEvents(startTime: String, endTime: String, date: String) -> [Row]{
        
        return  getEvents(startTime: timeFormatter.date(from: startTime)!,
                          endTime: timeFormatter.date(from: endTime)!,
                          date: dateFormatter.date(from: date)!)
        
    }
    
    func getEvents(startTime: Date, endTime: Date, date: Date) -> [Row]{
        
        let query = eventsTable.filter(
            !((columns.startTime < startTime && columns.endTime < startTime) ||
                (columns.startTime > endTime && columns.endTime > endTime))
                && columns.date == date)
        do{
            return Array(try db.prepare(query))
            
        } catch{
            fatalError("could not getEvents")
            
        }
    }
    
}
