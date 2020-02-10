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


enum EventRepeate: Int64{
    case none = 0, daily, weekely 
}

extension EventRepeate : Value{
    static var declaredDatatype: String {
        return "INTEGER"
    }

    static func fromDatatypeValue(_ datatypeValue: Int64) -> EventRepeate{
        return EventRepeate(rawValue: datatypeValue)!
    }

    var datatypeValue: Datatype {
        print("self.rawvalue = \(self.rawValue)")
        return self.rawValue
    }
}


class EventsDatabase {
    
    let db : Connection
    let eventsTable = Table("events")
    let columns = (id: Expression<Int64>("id"),
                   startTime: Expression<Date>("startTime"),
                   endTime: Expression<Date>("endTime"),
                   date: Expression<Date>("date"),
                   repeate: Expression<EventRepeate>("repeate"),
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
                t.column(columns.repeate)
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
                    repeate: repeate != nil ? repeate : nil,
                    iconPath: iconPath, imagePath: imagePath)
    }
    
    
    func updateEvent(cond: Expression<Bool>, startTime: Date? = nil, endTime: Date? = nil, date: Date? = nil,
                     repeate: EventRepeate? = nil, iconPath: String? = nil, imagePath: String? = nil, notification: Int64? = nil) {
        
        let filterExpr = eventsTable.filter(cond)
        var setters : [Setter] = []
        
        if let val = startTime{
            setters.append(columns.startTime <- stripDate(val))
        }
        
        if let val = endTime{
            setters.append(columns.endTime <- stripDate(val))
        }
        
        if let val = date{
            setters.append(columns.date <- stripTime(val))
        }
        
        if let val = repeate{
            setters.append(columns.repeate <- val)
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
                   date: dateFormatter.date(from: date)!, repeate: repeate, iconPath: iconPath, imagePath: imagePath)
    }
    
    func enterEvent(startTime: Date, endTime: Date, date: Date,
                    repeate: EventRepeate = .none, iconPath: String, imagePath: String, notification: Int64 = 0) {
        
        let insert = eventsTable.insert(
            columns.startTime <- stripDate(startTime),
            columns.endTime <- stripDate(endTime),
            columns.date <- stripTime(date),
            columns.repeate <- repeate,
            columns.icon <- iconPath,
            columns.image <- imagePath,
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
            !((columns.startTime < stripDate(startTime) && columns.endTime < stripDate(startTime)) ||
                (columns.startTime > stripDate(endTime) && columns.endTime > stripDate(endTime)))
            && columns.date == stripTime(date))
        do{
            return Array(try db.prepare(query))
            
        } catch{
            fatalError("could not getEvents")
            
        }
    }
    
    func stripTime(_ date: Date) -> Date{
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
    }
    
    func stripDate(_ date: Date) -> Date{
        let components = Calendar.current.dateComponents([.hour,.minute], from: date)
        let strippedDate = Calendar.current.date(from: components)
        return strippedDate!
    }
    
}
