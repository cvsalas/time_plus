//
//  DetailedEventsTableController.swift
//  Time+
//
//  Created by user165037 on 2/9/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit
import SQLite

class DetailedEventsTableController: NSObject, UITableViewDataSource, UITableViewDelegate {

    var events : [Row] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell") as! DetailedCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        cell.icon.text = "default"
        cell.iconeTitle.text = "default"
        let startTime = events[indexPath.row][EventsDatabase.sharedInstance.columns.startTime]
        let endTime = events[indexPath.row][EventsDatabase.sharedInstance.columns.endTime]
        
        
        cell.startTimeLabel.text = dateFormatter.string(from: startTime)
        cell.endTimeLabel.text = dateFormatter.string(from: endTime)
        
        return cell
        
    }
    
 

}
