//
//  File.swift
//  Time+
//
//  Created by user165037 on 2/18/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import Foundation


protocol EventsDataBaseStringEntry{
    var entry : String {get}
    init?(dataBaseString: String)
    
}

struct Icon : EventsDataBaseStringEntry{
    let name : String
    let code : UnicodeScalar
    
    var entry :String {return "\(code):\(name)"}
    
    init?(dataBaseString: String){
        let compArray = dataBaseString.components(separatedBy: ":")
        if let code = UnicodeScalar(compArray[0]){
            let name = compArray[1]
            self.init(name: name, code: code)
        }
        else{
            return nil
        }
    }
    
    init(name: String, code: UnicodeScalar){
        self.name = name
        self.code = code
    }
    
}

struct ImagePath : EventsDataBaseStringEntry{
    let path : String
    var entry: String {return path}
    init?(dataBaseString: String){
        path = dataBaseString
    }
    
    
}
