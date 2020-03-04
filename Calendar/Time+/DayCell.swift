//
//  DayCell.swift
//  Time+
//
//  Created by LibLabs-Mac on 11/29/19.
//  Copyright © 2019 LibLabs-Mac. All rights reserved.
//

import UIKit
import JTAppleCalendar
import SQLite

class DayCell: JTACDayCell {
    @IBOutlet weak var dayLabel: UILabel!
    
    var dots = [UIView]()
    
    var eventsIdicatorTag = 0
    var events: [Row]!
    var dotsCollectionViewDelegate : DotCollectionViewController!
    var dotsCollectionView : UICollectionView!
    
    func getNumOfCol(_ row:Int, totalElems: Int, dotsPerRow: Int) -> Int{
        let remElements = totalElems - (row)*dotsPerRow ;
        return remElements > 3 ? 3 : remElements
    }
    
   
    
    func drawEventDots() -> Void{
        
        dotsCollectionViewDelegate = DotCollectionViewController()
        dotsCollectionViewDelegate.events = events
        dotsCollectionView = attachDotsCollectionView()
        dotsCollectionView.backgroundColor = self.contentView.backgroundColor!
        dotsCollectionView.delegate = dotsCollectionViewDelegate
        dotsCollectionView.dataSource = dotsCollectionViewDelegate
        
        self.contentView.addSubview(dotsCollectionView)
        dotsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        dotsCollectionView.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 5).isActive = true
        dotsCollectionView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0).isActive = true
        dotsCollectionView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.65).isActive = true
        dotsCollectionView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.65).isActive = true
        dotsCollectionView.reloadData()
        
    }
    
    private func attachDotsCollectionView() -> UICollectionView{
        let tag = 0x0C011EC7 // arbitary tag
        eventsIdicatorTag = tag
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.tag = tag
        return collectionView
    }
    
    
    func clearDots(){
        for dot in dots{
            dot.removeFromSuperview()
        }
    }
    
}

class DotCollectionViewController: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var events: [Row]!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        AttachCircularView(cell: cell, eventIndex: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 3
        let cellsVertical: CGFloat = 2
        let flowLayout = (collectionViewLayout as! UICollectionViewFlowLayout)
        
        let spaceBetweenCells: CGFloat = flowLayout.minimumInteritemSpacing
        let spaceBetweenLines: CGFloat = flowLayout.minimumLineSpacing
        
        let width = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        let height = (collectionView.bounds.height - (cellsVertical - 1) * spaceBetweenLines) / cellsVertical
        return CGSize(width: width, height: height)
        
    }
    
    func AttachCircularView(cell: UICollectionViewCell, eventIndex: Int){
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(view)
        
        view.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        
        view.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: cell.contentView.centerXAnchor).isActive = true
        view.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.7).isActive = true
        
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        
        view.backgroundColor = getColorValue(event: events[eventIndex])
    }
    
    
    func getColorValue(event: Row) -> UIColor{
           let icon = Icon(dataBaseString: event[EventsDatabase.columns.icon])!
           let iconFromDatabase =  MainIconsDataBase.sharedInstance.get(icon: Int64(icon.code.value))
           if (iconFromDatabase.isEmpty){
               return UIColor.black
           }
           else{
               let colorValue = iconFromDatabase.first![MainIconsDataBase.columns.color]
               return UIColor(rgba: colorValue)
           }
       }
    
}
