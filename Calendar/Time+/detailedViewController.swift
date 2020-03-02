//
//  HourlyViewController.swift
//  Time+
//
//  Created by user165037 on 2/8/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class detailedViewController: UIViewController {

    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var viewStartTime: UILabel!
    @IBOutlet weak var viewEndTime: UILabel!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var TableViewOutlet: UITableView!
    
    
    
    var sender : DayTableController!
    let eventsTableController = DetailedEventsTableController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.dataSource = eventsTableController
        eventsTable.delegate = eventsTableController
        backgroundView.backgroundColor = UIColor(red:0.81, green:0.89, blue:0.79, alpha:1.0)
        TableViewOutlet.backgroundColor = UIColor(red:0.81, green:0.89, blue:0.79, alpha:1.0)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let startTime = dateFormatter.date(from: "\(sender.selectedRow):00")!
        let endTime = dateFormatter.date(from: "\(sender.selectedRow):59")!
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        viewStartTime.text = dateFormatter.string(from: startTime)
        viewEndTime.text = dateFormatter.string(from: endTime)

        let events = EventsDatabase.sharedInstance.getEvents(startTime: startTime, endTime: endTime, date: sender.view!.receivedDate)
        
        eventsTableController.events = events
        eventsTable.reloadData()
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
