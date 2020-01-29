//
//  DayTableController.swift
//  Time+
//
//  Created by Abdulhalim Rafeik on 1/28/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class DayTableController: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var clocksImages : [UIImage] = []
    let numOfCells = 24
    
    init(clocksDir: String){
        for _ in 0...numOfCells{
            clocksImages.append(UIImage(named: "Image")!)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell") as! HourCell
        let clock = (indexPath.row % 12) + 1
        let sun = indexPath.row < 11
        let sunMoonImage = UIImage(named: sun ? "sun" : "moon")
        
        
        cell.clockImage.image = UIImage(named: "\(clock)oClock")!
        cell.sunMoonImage.image = sunMoonImage
        
        return cell
    }

}
