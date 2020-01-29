//
//  SecondViewController.swift
//  Time+
//
//  Created by user165037 on 1/13/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourlyTable: UITableView!
    
    let tableController = DayTableController(clocksDir: "")
    var receivedDate = (weekDay: "", date: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyTable.dataSource = tableController
        hourlyTable.delegate = tableController
        
        weekDayLabel.text = receivedDate.weekDay
        dateLabel.text = receivedDate.date
        // Do any additional setup after loading the view.
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
