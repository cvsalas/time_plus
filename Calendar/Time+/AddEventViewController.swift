//
//  AddEventViewController.swift
//  Time+
//
//  Created by user165037 on 2/3/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, DatePickerWithDoneDelegate {
    
    fileprivate enum ButtonPressed{
        case Start, End
    }
    
    var startTime : Date!
    var endTime : Date!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    
    fileprivate var buttonPressed : ButtonPressed!
    var currentDay: Date!
    let dateFormatter = DateFormatter()
    @IBOutlet weak var repeateSegment: UISegmentedControl!
    
    let datePickerTag = 0xDEADBEEF
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        //setRepeatControlAppearance()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        if let start = startTime, let end = endTime{
            EventsDatabase.sharedInstance.enterEvent(startTime: start, endTime: end, date: currentDay, iconPath: "", imagePath: "")
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func setRepeatControlAppearance(){
        let size = CGSize(width: 117.333,height: 72)
        UIGraphicsBeginImageContext(size)
        defer {UIGraphicsEndImageContext()}
        UIColor.green.setFill()
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: size.height/2).fill()
        let image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
        
        repeateSegment.setBackgroundImage(image, for: .normal, barMetrics: .default)
    }
    
    @IBAction func endTimeButtonPressed(_ sender: Any) {
        displayPickere()
        buttonPressed = .End
    }
    @IBAction func startTimeButtonPressed(_ sender: Any) {
        displayPickere()
        buttonPressed = .Start
    }
    
    func displayPickere(){
        self.view.viewWithTag(datePickerTag)?.removeFromSuperview()

        let height = self.view.frame.size.height/2
        let datePicker = DatePickerWithDone(frame: CGRect(x: 0, y: self.view.frame.size.height - height, width: self.view.frame.size.width, height: height))
        
        datePicker.datePickerMode = .time
        datePicker.delegate = self
        datePicker.tag = datePickerTag
        self.view.addSubview(datePicker)
    }
    

    
    func doneTapped(picker: DatePickerWithDone) {
        setTimes(picker: picker)
        picker.removeFromSuperview()
    }
    
    func pickerWillDisappear(picker: DatePickerWithDone) {
        setTimes(picker: picker)
    }
    
    func setTimes(picker: DatePickerWithDone){
        if(buttonPressed == .Start){
            self.startTime = picker.date
            self.startTimeLabel.text = self.dateFormatter.string(from: self.startTime)
        }
        else{
            self.endTime = picker.date
            self.endTimeLabel.text = self.dateFormatter.string(from: self.endTime)
        }
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
