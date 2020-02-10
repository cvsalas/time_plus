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
        
        cell.clockImage.image = UIImage(named: "\(clock)oClock")!
        cell.amPmLabel.text = timeString
        
        populateHourPart(partImages: &cell.firstHalfImages, row: indexPath.row, begMinute: "00", endMinute: "29", defaultImage: UIImage(named: "\(clock)oClock")!)
        populateHourPart(partImages: &cell.secondHalfImages, row: indexPath.row, begMinute: "30", endMinute: "59", defaultImage: UIImage(named: "\(clock)oClock")!)
        
        return cell
        
        
    }
    
    func populateHourPart( partImages: inout [UIImageView], row: Int, begMinute: String, endMinute: String, defaultImage: UIImage?){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = 2
        
        
        let firstPart: Date = dateFormatter.date(from: "\(numberFormatter.string(from: NSNumber(value:row))!):\(begMinute)")!
        let secondPart: Date = dateFormatter.date(from: "\(numberFormatter.string(from: NSNumber(value: row))!):\(endMinute)")!
        let events = EventsDatabase.sharedInstance.getEvents(startTime: firstPart, endTime: secondPart, date: view!.receivedDate)
        
        if events.count >= 1 {
            partImages[0].image =  events[0][EventsDatabase.sharedInstance.columns.image] == "" ?  defaultImage! : UIImage(named: events[0][EventsDatabase.sharedInstance.columns.image])
            if events.count >= 2{
                partImages[1].image =  events[1][EventsDatabase.sharedInstance.columns.image] == "" ?  defaultImage! : UIImage(named: events[1][EventsDatabase.sharedInstance.columns.image])
                if events.count > 2 {
                    let extensionImage = defaultImage
                    partImages[2].image = extensionImage
                }
            }
        }
    }
    
    func resetCell(cell: HourCell){
        for imageView in cell.firstHalfImages{
            imageView.image = nil
        }
        for imageView in cell.secondHalfImages{
            imageView.image = nil
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        view?.performSegue(withIdentifier: "toHourlyView", sender: self)
    }
    
}
