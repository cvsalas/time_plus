//
//  AddEventViewController.swift
//  Time+
//
//  Created by user165037 on 2/3/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController {
    
    
    var startTime : Date!
    var endTime : Date!
    var icon : UIImage!
    @IBOutlet weak var repeateSegment: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    @IBAction func DoneButtonPressed(_ sender: Any) {
        if let start = startTime, let end = endTime{
            EventsDatabase.sharedInstance.enterEvent(startTime: start, endTime: end, date: Date(), iconPath: "", imagePath: "")
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    @IBAction func endTimeButtonPressed(_ sender: Any) {
        displayPickere(){ picker in
            self.endTime = picker.date
            picker.removeFromSuperview()
        }
    }
    @IBAction func startTimeButtonPressed(_ sender: Any) {
        displayPickere(){ picker in
            self.startTime = picker.date
            picker.removeFromSuperview()
        }
    }
    
    func displayPickere(doneFunc: @escaping (DatePickerWithDone)->Void){
        let height = self.view.frame.size.height/2
        
        let datePicker = DatePickerWithDone(frame: CGRect(x: 0, y: self.view.frame.size.height - height, width: self.view.frame.size.width, height: height))
        datePicker.datePickerMode = .time
        datePicker.doneFunction = doneFunc
        self.view.addSubview(datePicker)
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
