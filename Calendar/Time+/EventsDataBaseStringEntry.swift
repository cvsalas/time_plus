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
    
}

struct Icon : EventsDataBaseStringEntry{
    let name : String
    let code : UnicodeScalar
    
    var entry :String {return "\(code):\(name)"}
}

struct ImagePath : EventsDataBaseStringEntry{
    let path : String
    var entry: String {return path}
}
