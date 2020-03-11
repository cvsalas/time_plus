//
//  HourlyViewController.swift
//  Time+
//
//  Created by user165037 on 2/8/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var viewStartTime: UILabel!
    @IBOutlet weak var viewEndTime: UILabel!
    @IBOutlet weak var eventsTable: UITableView!
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var sender : DailyViewController!
    var startTime : Date!
    var endTime : Date!
    var date : Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsTable.dataSource = self
        eventsTable.delegate = self
        backgroundView.backgroundColor = UIColor(red:0.81, green:0.89, blue:0.79, alpha:1.0)
        tableViewOutlet.backgroundColor = UIColor(red:0.81, green:0.89, blue:0.79, alpha:1.0)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        startTime = dateFormatter.date(from: "\(sender.selectedRow!):00")!
        endTime = dateFormatter.date(from: "\(sender.selectedRow!):59")!
        date = sender.receivedDate
        
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        viewStartTime.text = dateFormatter.string(from: startTime)
        viewEndTime.text = dateFormatter.string(from: endTime)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        eventsTable.reloadData()
    }
}

extension DetailedViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventsDatabase.sharedInstance.getEvents(startTime: startTime, endTime: endTime, date: sender.receivedDate).count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailedCell") as! DetailedCell
        let events = EventsDatabase.sharedInstance.getEvents(startTime: startTime, endTime: endTime, date: sender.receivedDate)
        resetCell(cell: cell)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        
        let thisIcon = Icon(dataBaseString: events[indexPath.row][EventsDatabase.columns.icon])!
        cell.icon.font = UIFont(name: "FontAwesome5Free-Solid", size: 40)
        cell.icon.text = String(thisIcon.code)
        cell.iconeTitle.text = thisIcon.name
        let startTime = events[indexPath.row][EventsDatabase.columns.startTime]
        let event = events[indexPath.row]
        
        let endTime = event[EventsDatabase.columns.endTime]
        let entry = event[EventsDatabase.columns.image]
        
        if (!entry.isEmpty){
            if let icon = Icon(dataBaseString: entry){
                setConstraintsView(view: IconView(icon: icon, frame: .zero), superview: cell.detailedInfo)
            }
            else{
                
                let fullPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(entry)
                setConstraintsImage(image: UIImage(contentsOfFile: fullPath)!, superview: cell.detailedInfo)
            }
        }
        
        cell.startTimeLabel.text = dateFormatter.string(from: startTime)
        cell.endTimeLabel.text = dateFormatter.string(from: endTime)
        cell.eventId = event[EventsDatabase.columns.id]
        attachGestureRecognizer(cell: cell)
        return cell
        
    }
    
    func resetCell(cell: DetailedCell){
        while let subview = cell.detailedInfo.subviews.last {
            subview.removeFromSuperview()
        }
    }
    
    func setConstraintsImage(image: UIImage, superview: UIView) {
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        let heightRatio = superview.frame.height / image.size.height
        let widthRatio = superview.frame.width / image.size.width
        superview.addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        
        imageView.layoutIfNeeded()
        if(heightRatio < widthRatio){
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: imageView.bounds.size.width / imageView.bounds.size.height).isActive = true
            imageView.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1.0).isActive = true
        }
        else{
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: imageView.bounds.size.height / imageView.bounds.size.width).isActive = true
            imageView.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0).isActive = true
            
        }
        
    }
    
    func setConstraintsView(view: UIView, superview: UIView){
        superview.addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true
        view.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 0.8).isActive = true
        view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 0.8).isActive = true
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func attachGestureRecognizer(cell: DetailedCell){
        cell.isUserInteractionEnabled = true
        let holdRecog = UILongPressGestureRecognizer(target: self, action: #selector(holdGestureRecognized))
        holdRecog.minimumPressDuration = 0.5
        cell.addGestureRecognizer(holdRecog)
    }
    
    @objc func holdGestureRecognized(_ sender: UILongPressGestureRecognizer) {
        let cell = sender.view as! DetailedCell
        print("howdy")
        let path = tableViewOutlet.indexPath(for: cell)
        if let indexPath = path {
            EventsDatabase.sharedInstance.deleteEvent(id: cell.eventId)
            tableViewOutlet.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}



extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
