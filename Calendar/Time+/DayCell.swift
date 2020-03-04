//
//  DayCell.swift
//  Time+
//
//  Created by LibLabs-Mac on 11/29/19.
//  Copyright © 2019 LibLabs-Mac. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SQLite

class DayCell: JTACDayCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    var dots = [UIView]()
    
    func getNumOfCol(_ row:Int, totalElems: Int, dotsPerRow: Int) -> Int{
        let remElements = totalElems - (row)*dotsPerRow ;
        return remElements > 3 ? 3 : remElements
    }
    
    func getColorValue(event: Row) -> UIColor{
        let icon = Icon(dataBaseString: event[EventsDatabase.columns.icon])!
        let iconFromDatabase =  MainIconsDataBase.sharedInstance.get(icon: Int64(icon.code.value))
        if (iconFromDatabase.isEmpty){
            return UIColor.black
        }
        else{
            let colorValue = iconFromDatabase.first![MainIconsDataBase.columns.color]
            return UIColor(rgba: colorValue)
        }
    }
    
    func drawEventDots(events: [Row]) -> Void{
        
        let dotsPerRow = 3
        let rowSpacing = 7.0, colSpacing = 5.0
        let vertOffset = Double(dayLabel.frame.maxY)-7.0, horizOffset = 10.0
        let eventDotPerim = 5.0
        let numEvents = events.count
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 255).cgColor
        
        for i in 0..<Int(ceil(Double(numEvents)/Double(dotsPerRow))) {
            for j in 0..<getNumOfCol(i, totalElems: numEvents, dotsPerRow: dotsPerRow){
                let eventDot = CGRect(x: Double(j)*colSpacing + horizOffset + Double(eventDotPerim/2.0),
                                      y: Double(i + 1)*rowSpacing + vertOffset +  Double(eventDotPerim/2.0),
                                      width: eventDotPerim, height: eventDotPerim)
                
                let dotView = UIView(frame: eventDot)
                dotView.backgroundColor = getColorValue(event: events[i*dotsPerRow+j])
                dotView.layer.cornerRadius = CGFloat(eventDotPerim/2.0)
                self.addSubview(dotView)
                dots.append(dotView)
            }
            
        }
    }
    
    func clearDots(){
        for dot in dots{
            dot.removeFromSuperview()
        }
    }
    
}
