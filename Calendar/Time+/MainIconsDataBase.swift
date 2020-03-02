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

class MainIconsDataBase {
    
    let db : Connection
    let mainIconsTable = Table("mainIcons")
    static let columns = (icon: Expression<Int64>("icon"),
                          name: Expression<String>("name"),
                          color: Expression<Int64>("color"))
    
    
    let dataBasePath =  "\(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!)/db.sqlite3"
    
    static let sharedInstance = MainIconsDataBase()
    
    private init(){
        do{
            db = try Connection(dataBasePath)
            try db.run(mainIconsTable.create(ifNotExists: true) { t in
                t.column(MainIconsDataBase.columns.icon, primaryKey: true)
                t.column(MainIconsDataBase.columns.name)
                t.column(MainIconsDataBase.columns.color)
            })
            
        } catch Result.error(let message, let code, let statment){
            fatalError("\(message) error code: \(code) statment: \(String(describing: statment))")
        } catch {
            fatalError("unknown error opening database")
        }
        
    }
    
    
    func update(cond: Expression<Bool>, icon: Int64? = nil, name: String? = nil, color: Int64? = nil) {
        
        let filterExpr = mainIconsTable.filter(cond)
        var setters : [Setter] = []
        
        if let val = icon{
            setters.append(MainIconsDataBase.columns.icon <- val)
        }
        
        if let val = name{
            setters.append(MainIconsDataBase.columns.name <- val)
        }
        
        if let val = color{
            setters.append(MainIconsDataBase.columns.color <- val)
        }
        do{
            try db.run(filterExpr.update(setters))
        } catch {
            fatalError("Could not update value")
        }
        
    }
    
    func enter(icon: Int64, name: String, color: Int64) {
        
        let insert = mainIconsTable.insert(
            MainIconsDataBase.columns.icon <- icon,
            MainIconsDataBase.columns.name <- name,
            MainIconsDataBase.columns.color <- color)
        
        do{
            try db.run(insert)
        } catch Result.error(let message, let code, let statment){
            fatalError("\(message) error code: \(code) statment: \(String(describing: statment))")
        } catch{
            fatalError("could not insert")
        }
        
    }
    
    func get(icon: Int64? = nil) -> [Row]{
        let query = icon != nil ? mainIconsTable.filter(MainIconsDataBase.columns.icon == icon!)
            : mainIconsTable
        
        do{
            return Array(try db.prepare(query))
            
        } catch{
            fatalError("could not getEvents")
            
        }
    }
}

extension UIColor{
    convenience init(rgba: Int64){
        let r = CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let g = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let b = CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let a = CGFloat((rgba & 0x000000FF)) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    var rgba : Int64 {
        let components = self.cgColor.components!
        
        let r = lroundf(Float(components[0]) * 255)
        let g = lroundf(Float(components[1]) * 255)
        let b = lroundf(Float(components[2]) * 255)
        let a = components.count >= 4 ? lroundf(Float(components[3]) * 255) : 255
        
        let rgba = (r << 24) | (g << 16) | (b << 8) | a
        return Int64(rgba)
        
    }
}
