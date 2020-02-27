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
        resetCell(cell: cell)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        let thisIcon = parseString(iconSelected: events[indexPath.row][EventsDatabase.columns.icon])
        cell.icon.font = UIFont(name: "FontAwesome5Free-Solid", size: 40)
        cell.icon.text = String(thisIcon.code)
        cell.iconeTitle.text = thisIcon.name
        let startTime = events[indexPath.row][EventsDatabase.columns.startTime]
        let endTime = events[indexPath.row][EventsDatabase.columns.endTime]

        let imageName = events[indexPath.row][EventsDatabase.columns.image]
            let fullPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
        setConstraintsImage(image: UIImage(contentsOfFile: fullPath)!, superview: cell.detailedInfo)
        cell.startTimeLabel.text = dateFormatter.string(from: startTime)
        cell.endTimeLabel.text = dateFormatter.string(from: endTime)
        
        return cell
        
    }
    
    func resetCell(cell: DetailedCell){
        while let subview = cell.detailedInfo.subviews.last {
            subview.removeFromSuperview()
        }
    }
    
    // DOCUMENTATION: THE CENTERING OF THE IMAGES IS NOT GOOD, WE GIVE UP!!
    func setConstraintsImage(image: UIImage, superview: UIView) {
        let imageView: UIImageView = UIImageView()
        imageView.image = image
        let heightRatio = superview.frame.height / image.size.height
        let widthRatio = superview.frame.width / image.size.width
        let scale = min(heightRatio, widthRatio)
        imageView.frame.size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        imageView.center = CGPoint(x: superview.bounds.midX,
                                   y: superview.bounds.midY)
        superview.addSubview(imageView)
    }
    
    func parseString(iconSelected : String) -> Icon {
        let compArray = iconSelected.components(separatedBy: ":")
        let code = UnicodeScalar(compArray[0])
        let name = compArray[1]
        let icon = Icon(name: name, code: code!)
        return icon
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
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
