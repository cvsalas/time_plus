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
    static let columns = (id: Expression<Int64>("id"),
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
    static let defaultTimeFormat = "HH:mm"
    static let defaultDateFormat = "yyyy-MM-dd"
    
    private init(){
        do{
            db = try Connection(dataBasePath)
            try db.run(eventsTable.create(ifNotExists: true) { t in
                t.column(EventsDatabase.columns.id, primaryKey: .autoincrement)
                t.column(EventsDatabase.columns.startTime)
                t.column(EventsDatabase.columns.endTime)
                t.column(EventsDatabase.columns.date)
                t.column(EventsDatabase.columns.repeate)
                t.column(EventsDatabase.columns.icon)
                t.column(EventsDatabase.columns.image)
                t.column(EventsDatabase.columns.notification)
            })
            
        } catch Result.error(let message, let code, let statment){
            fatalError("\(message) error code: \(code) statment: \(String(describing: statment))")
        } catch {
            fatalError("unknown error opening database")
        }
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = EventsDatabase.defaultDateFormat
        
        timeFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        timeFormatter.dateFormat = EventsDatabase.defaultTimeFormat
    }
    
    func updateEvents(cond: Expression<Bool>,  startTime: String? = nil, endTime: String? = nil, date: String? = nil,
                      repeate: EventRepeate? = nil, iconPath: String? = nil, imagePath: String? = nil, notification: Int64? = nil, timeFormat: String = EventsDatabase.defaultTimeFormat, dateFormat: String = EventsDatabase.defaultTimeFormat){
        timeFormatter.dateFormat = timeFormat
        dateFormatter.dateFormat = dateFormat
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
            setters.append(EventsDatabase.columns.startTime <- stripDate(val))
        }
        
        if let val = endTime{
            setters.append(EventsDatabase.columns.endTime <- stripDate(val))
        }
        
        if let val = date{
            setters.append(EventsDatabase.columns.date <- stripTime(val))
        }
        
        if let val = repeate{
            setters.append(EventsDatabase.columns.repeate <- val)
        }
        
        if let val = iconPath{
            setters.append(EventsDatabase.columns.icon <- val)
        }
        
        if let val = imagePath{
            setters.append(EventsDatabase.columns.image <- val)
        }
        
        if let val = notification{
            setters.append(EventsDatabase.columns.notification <- val)
        }
        
        do{
            try db.run(filterExpr.update(setters))
        } catch {
            fatalError("Could not update value")
        }
        
    }
    
    
    func enterEvent(startTime: String, endTime: String, date: String,
                    repeate: EventRepeate = .none, iconPath: String, imagePath: String, notification: Int64 = 0, timeFormat: String = EventsDatabase.defaultTimeFormat, dateFormat: String = EventsDatabase.defaultTimeFormat) {
        
        timeFormatter.dateFormat = timeFormat
        dateFormatter.dateFormat = dateFormat
        
        enterEvent(startTime: timeFormatter.date(from: startTime)!, endTime: timeFormatter.date(from: endTime)!,
                   date: dateFormatter.date(from: date)!, repeate: repeate, iconPath: iconPath, imagePath: imagePath)
    }
    
    func enterEvent(startTime: Date, endTime: Date, date: Date,
                    repeate: EventRepeate = .none, iconPath: String, imagePath: String, notification: Int64 = 0) {
        
        let insert = eventsTable.insert(
            EventsDatabase.columns.startTime <- stripDate(startTime),
            EventsDatabase.columns.endTime <- stripDate(endTime),
            EventsDatabase.columns.date <- stripTime(date),
            EventsDatabase.columns.repeate <- repeate,
            EventsDatabase.columns.icon <- iconPath,
            EventsDatabase.columns.image <- imagePath,
            EventsDatabase.columns.notification <- 0)
        
        do{
            try db.run(insert)
        }catch{
            fatalError("could not insert")
        }
        
    }
    
    func getEvents(startTime: String, endTime: String, date: String, timeFormat: String = EventsDatabase.defaultTimeFormat, dateFormat: String = EventsDatabase.defaultTimeFormat) -> [Row]{
    
        timeFormatter.dateFormat = timeFormat
        dateFormatter.dateFormat = dateFormat
        
        return  getEvents(startTime: timeFormatter.date(from: startTime)!,
                          endTime: timeFormatter.date(from: endTime)!,
                          date: dateFormatter.date(from: date)!)
        
    }
    
    func getEvents(startTime: Date, endTime: Date, date: Date) -> [Row]{
        let query = eventsTable.filter(
            !((EventsDatabase.columns.startTime < stripDate(startTime) && EventsDatabase.columns.endTime < stripDate(startTime)) ||
                (EventsDatabase.columns.startTime > stripDate(endTime) && EventsDatabase.columns.endTime > stripDate(endTime)))
            && EventsDatabase.columns.date == stripTime(date))
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
