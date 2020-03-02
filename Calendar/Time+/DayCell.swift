//
//  DayCell.swift
//  Time+
//
//  Created by LibLabs-Mac on 11/29/19.
//  Copyright © 2019 LibLabs-Mac. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DayCell: JTACDayCell {
    @IBOutlet weak var dayLabel: UILabel!


    func getNumOfCol(_ row:Int, totalElems: Int, dotsPerRow: Int) -> Int{
        let remElements = totalElems - (row-1)*dotsPerRow ;
        return remElements > 3 ? 3 : remElements
    }
    
    func drawEventDots(_ numEvents: Int) -> Void{

        let dotsPerRow = 3
        let rowSpacing = 7.0, colSpacing = 5.0
        let vertOffset = Double(dayLabel.frame.maxY)-7.0, horizOffset = 10.0
        let eventDotPerim = 5.0

        layer.borderWidth = 1.0
        layer.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 255).cgColor
       
        for i in 1...Int(ceil(Double(numEvents)/Double(dotsPerRow))){
            for j  in 0...getNumOfCol(i, totalElems: numEvents, dotsPerRow: dotsPerRow) - 1{
                let eventDot = CGRect(x: Double(j)*colSpacing + horizOffset + Double(eventDotPerim/2.0),
                                      y: Double(i)*rowSpacing + vertOffset +  Double(eventDotPerim/2.0),
                                      width: eventDotPerim, height: eventDotPerim)
                
                let dotView = UIView(frame: eventDot)
                dotView.backgroundColor = .red
                dotView.layer.cornerRadius = CGFloat(eventDotPerim/2.0)
                self.addSubview(dotView)
                self.draw(eventDot)
            }
            
        }
    }
    
}
