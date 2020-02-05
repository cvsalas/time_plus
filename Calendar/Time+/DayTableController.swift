//
//  DayTableController.swift
//  Time+
//
//  Created by Abdulhalim Rafeik on 1/28/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class DayTableController: NSObject, UITableViewDelegate, UITableViewDataSource {
    func doneTapped() {
        print("hello")
    }
    
    
    var clocksImages : [UIImage] = []
    let numOfCells = 24
    var view : DailyViewController?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell") as! HourCell
        let clock = (indexPath.row % 12) + 1
        let sun = indexPath.row < 11
        let sunMoonImage = UIImage(named: sun ? "sun" : "moon")
        
        
        cell.clockImage.image = UIImage(named: "\(clock)oClock")!
        cell.sunMoonImage.image = sunMoonImage
        
        return cell
        
        
    }
    
    func populateHourPart(cell: HourCell, row: Int, begMinute: String, endMinute: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = 2
        
        
        let firstPart: Date = dateFormatter.date(from: "\(numberFormatter.string(from: NSNumber(value:row))!):\(begMinute)")!
        let secondPart: Date = dateFormatter.date(from: "\(numberFormatter.string(from: NSNumber(value: row))!)\(endMinute)")!
        
        
        let events = EventsDatabase.sharedInstance.getEvents(startTime: firstPart, endTime: secondPart, date: view!.receivedDate)
        
        cell.firstHalfImages[0].image =  events[0][EventsDatabase.sharedInstance.columns.image] == "" ?  cell.clockImage.image! : UIImage(named: events[0][EventsDatabase.sharedInstance.columns.image])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        view?.performSegue(withIdentifier: "toAddEvent", sender: view)
    }
    
}
