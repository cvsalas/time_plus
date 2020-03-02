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

class ViewController: UIViewController, JTACMonthViewDelegate, JTACMonthViewDataSource {
    
    @IBOutlet weak var calendarView: JTACMonthView!
    
    fileprivate var selectedDate = Date()
    fileprivate let formatter  = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollingMode = .stopAtEachCalendarFrame
        calendarView.scrollDirection = .horizontal
        // Do any additional setup after loading the view.

        setupFAQ()
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
        let endDate = formatter.date(from: "2020 12 31")
        return ConfigurationParameters(startDate: startDate, endDate: endDate!)
        
    }
        
    func configureCell(jtCell: JTACDayCell, state: CellState, date: Date){
        let cell = jtCell as! DayCell
        let calendar = Calendar.current
        
        cell.dayLabel.text = state.text
        cell.drawEventDots(5)
        
        
        if state.dateBelongsTo == .thisMonth{
            if calendar.isDate(date, equalTo: Date(), toGranularity: .day){
                cell.contentView.backgroundColor = UIColor(red:0.24, green:0.51, blue:0.98, alpha:1.0)

            }
        }
        else{
            cell.dayLabel.textColor = .gray;
        }
        
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

