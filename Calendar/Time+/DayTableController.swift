//
//  DayTableController.swift
//  Time+
//
//  Created by Abdulhalim Rafeik on 1/28/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class DayTableController: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var clocksImages : [UIImage] = []
    let numOfCells = 24
    var view : DailyViewController?
    
    var selectedRow = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell") as! HourCell
        let clock = indexPath.row == 0 || indexPath.row == 12 ? 12 : (indexPath.row % 12)
        let am = indexPath.row < 12
        let timeString = "\(clock)\(am ? "am" : "pm")"
        
        resetCell(cell: cell)
        
        cell.ClockImage.image = UIImage(named: "\(clock)oClock")!
        cell.AMPMLabel.text = timeString
        
        populateHourPart(thisView: &cell.TopHalfViews, row: indexPath.row, begMinute: "00", endMinute: "29")
        populateHourPart(thisView: &cell.BottomHalfViews, row: indexPath.row, begMinute: "30", endMinute: "59")
        
        return cell
    }
    
    func populateHourPart(thisView: inout [UIView], row: Int, begMinute: String, endMinute: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = 2
        
        
        let firstPart: Date = dateFormatter.date(from: "\(numberFormatter.string(from: NSNumber(value:row))!):\(begMinute)")!
        let secondPart: Date = dateFormatter.date(from: "\(numberFormatter.string(from: NSNumber(value: row))!):\(endMinute)")!
        let events = EventsDatabase.sharedInstance.getEvents(startTime: firstPart, endTime: secondPart, date: view!.receivedDate)
        if events.count >= 1 {
            setConstraintsIcon(icon: parseString(iconSelected: events[0][EventsDatabase.columns.icon]), superview: thisView[0])
            if events.count >= 2{
                setConstraintsIcon(icon: parseString(iconSelected: events[1][EventsDatabase.columns.icon]), superview: thisView[1])
                if events.count > 2 {
                    setConstraintsIcon(icon: parseString(iconSelected: events[2][EventsDatabase.columns.icon]), superview: thisView[2])
                    
                }
            }
        }
    }
    func setConstraintsIcon(icon: IconView, superview: UIView) {
        superview.addSubview(icon)
        icon.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0).isActive = true
        icon.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1.0).isActive = true
        icon.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        icon.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        
    }
    
    func parseString(iconSelected : String) -> IconView {
        let compArray = iconSelected.components(separatedBy: ":")
        let code = UnicodeScalar(compArray[0])
        let name = compArray[1]
        let icon = Icon(name: name, code: code!)
        let iconView = IconView(icon: icon, iconFontSize: 20, nameFontSize: 15, frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        return iconView
    }
    
    func resetCell(cell: HourCell){
        for view in cell.TopHalfViews{
            while let subview = view.subviews.last {
                subview.removeFromSuperview()
            }
        }
        for view in cell.BottomHalfViews{
            while let subview = view.subviews.last {
                subview.removeFromSuperview()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        view?.performSegue(withIdentifier: "toHourlyView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
}
