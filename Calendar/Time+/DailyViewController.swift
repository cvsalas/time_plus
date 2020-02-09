//
//  SecondViewController.swift
//  Time+
//
//  Created by user165037 on 1/13/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController {

    
    @IBOutlet weak var weekDayLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var hourlyTable: UITableView!
    
    var tableController : DayTableController!
    var receivedDate : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableController = DayTableController()
        tableController.view = self
        hourlyTable.dataSource = tableController
        hourlyTable.delegate = tableController
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM dd "
        let dateElements = formatter.string(from: receivedDate).components(separatedBy: ",")
        weekDayLabel.text = dateElements[0]
        dateLabel.text = dateElements[1]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hourlyTable.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let addEventView = segue.destination as! AddEventViewController
        addEventView.currentDay = receivedDate
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
