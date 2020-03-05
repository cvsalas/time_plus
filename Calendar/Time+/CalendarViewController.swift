//
//  ViewController.swift
//  Time+
//
//  Created by LibLabs-Mac on 11/28/19.
//  Copyright © 2019 LibLabs-Mac. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SemiModalViewController

class CalendarViewController: UIViewController, JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    @IBOutlet var calendarView: JTACMonthView!
    
    fileprivate var selectedDate = Date()
    fileprivate let formatter  = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        // Do any additional setup after loading the view.
        
        setupFAQ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.reloadData()
        
    }
    
    @IBAction func FAQButton(_ sender: Any) {
        let options = [
            SemiModalOption.pushParentBack: false,
            SemiModalOption.shadowOpacity: 0.5
            ] as [SemiModalOption : Any]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let identifier = String(describing: helpScreenViewController.self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier)
        
        controller.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.5, height: self.view.frame.height * 0.5)
        controller.view.backgroundColor = UIColor.lightGray
        
        presentSemiViewController(controller, options: options, completion: {
            print("Completed!")
        }, dismissBlock: {
            print("Dismissed!")
        })
    }
    
    @IBOutlet weak var FAQ_Outlet: UIButton!
    func setupFAQ(){
        FAQ_Outlet.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 30)!
        FAQ_Outlet.setTitle("\u{f059}", for: .normal)
    }
    
    func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DayCell
        configureCell(jtCell: cell, state: cellState, date: date)
    }
    
    func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dayCell", for: indexPath) as! DayCell
        configureCell(jtCell: cell, state: cellState, date: date)
        return cell
    }
    
    func calendar(_ calendar: JTACMonthView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTACMonthReusableView{
        formatter.dateFormat = "MMMM yyyy"
        let dateString = formatter.string(from: range.start).components(separatedBy: " ")
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "MonthHeader", for: indexPath) as! MonthHeaderClass
        header.monthLabel.text = dateString[0] + " " + dateString[1]
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTACMonthView?) -> MonthSize?{
        return MonthSize(defaultSize: 110)
    }
    
    
    func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let startDate = Date()
        //Year spans from current date to 2 years from now 
        let yearInSeconds = 31557600 * 2
        let endYear = startDate.advanced(by: TimeInterval(exactly: yearInSeconds)!)
        let endDate = endYear
        return ConfigurationParameters(startDate: startDate, endDate: endDate)
        
    }
    
    func configureCell(jtCell: JTACDayCell, state: CellState, date: Date){
        let cell = jtCell as! DayCell
        resetCell(cell: cell)
        let calendar = Calendar.current
        
        cell.dayLabel.text = state.text
        let eventsForDate = EventsDatabase.sharedInstance.getEvents(date: date)
        
        
        if state.dateBelongsTo == .thisMonth{
            if calendar.isDate(date, equalTo: Date(), toGranularity: .day){
                cell.contentView.backgroundColor = UIColor(red:0.83, green:1.00, blue:0.91, alpha:0.8)
                cell.contentView.layer.cornerRadius = 5
                
            }
        }
        else{
            cell.dayLabel.textColor = .gray;
        }
        cell.events = eventsForDate
        cell.drawEventDots()
        
        
    }
    
    func resetCell(cell: DayCell){
        cell.contentView.backgroundColor = .white
        cell.dayLabel.textColor = .black
        cell.clearDots()
    }
    
    func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath){
        selectedDate = date
        performSegue(withIdentifier: "firstLink", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "firstLink"){
            let dayView = segue.destination as! DailyViewController
            dayView.receivedDate = selectedDate
        }
        
    }
}

