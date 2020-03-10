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
    
    var receivedDate : Date!
    var selectedRow : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hourlyTable.dataSource = self
        hourlyTable.delegate = self
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM dd "
        let dateElements = formatter.string(from: receivedDate).components(separatedBy: ",")
        weekDayLabel.text = dateElements[0]
        print(dateElements[0])
        dateLabel.text = dateElements[1]
        weekDayLabel.sizeToFit()
        dateLabel.sizeToFit()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hourlyTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier{
            
        case "toAddEvent":
            let addEventView = segue.destination as! AddEventViewController
            addEventView.currentDay = receivedDate
            
        case "toHourlyView":
            let hourlyView = segue.destination as! DetailedViewController
            hourlyView.sender = self
            
        default:
            fatalError("attempt to jump using unidentified sigue")
        }
        
    }
    
    @IBAction func addEventButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "toAddEvent", sender: self)
        
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

extension DailyViewController : UITableViewDataSource, UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
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
        let events = EventsDatabase.sharedInstance.getEvents(startTime: firstPart, endTime: secondPart, date: receivedDate)
        if events.count >= 1 {
            setConstraintsIcon(icon: IconView(icon: Icon(dataBaseString: events[0][EventsDatabase.columns.icon])!), superview: thisView[0])
            if events.count >= 2{
                setConstraintsIcon(icon: IconView(icon: Icon(dataBaseString: events[0][EventsDatabase.columns.icon])!), superview: thisView[1])
                if events.count > 2 {
                    setConstraintsIcon(icon: IconView(icon: Icon(dataBaseString: events[0][EventsDatabase.columns.icon])!), superview: thisView[2])
                    
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
        
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "toHourlyView", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
