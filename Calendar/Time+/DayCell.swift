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
    
    var eventsIdicatorTag = 0xDEADBEEF // zero doesn't work because all views have zero by default
    
    var events: [Row]! {
        didSet{
            attachEventsIndicator()
        }
    }
    
    // must be a member variable so that it can contain the events for each DayCell instance independently .
    let dotsCollectionViewDelegate = DotCollectionViewController()
    
    func getNumOfCol(_ row:Int, totalElems: Int, dotsPerRow: Int) -> Int{
        let remElements = totalElems - (row)*dotsPerRow ;
        return remElements > 3 ? 3 : remElements
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func clearEventsIndicator(){
        self.viewWithTag(eventsIdicatorTag)?.removeFromSuperview()
    }
    
    private func attachEventsIndicator() -> Void{
        
        guard !events.isEmpty else {
            return
        }
        //Attach the collection view if <= 6 events in that cell
        var eventsIndicator: UIView!
        
        if(events.count <= 6){
            let dotsCollectionView = createDotsCollectionView()
            dotsCollectionViewDelegate.events = events
            dotsCollectionView.delegate = dotsCollectionViewDelegate
            dotsCollectionView.dataSource = dotsCollectionViewDelegate
            eventsIndicator = dotsCollectionView
            dotsCollectionView.reloadData()
        } else {
            let eventsLabel = createEventsCountLabel()
            self.contentView.addSubview(eventsLabel)
            eventsLabel.text = String(events.count)
            eventsLabel.textAlignment = .center
            eventsLabel.font = UIFont(name:"HelveticaNeue-Bold", size: 20.0)
            eventsIndicator = eventsLabel
        }
        
        self.addSubview(eventsIndicator)
        eventsIndicator.isUserInteractionEnabled = false
        eventsIndicator.translatesAutoresizingMaskIntoConstraints = false
        eventsIndicator.backgroundColor = self.contentView.backgroundColor
        eventsIndicator.translatesAutoresizingMaskIntoConstraints = false
        eventsIndicator.topAnchor.constraint(equalTo: dayLabel.bottomAnchor, constant: 2).isActive = true
        eventsIndicator.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor, constant: 0).isActive = true
        eventsIndicator.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.6).isActive = true
        eventsIndicator.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.7).isActive = true
    }
    
    private func createDotsCollectionView() -> UICollectionView{
        let tag = 0x0C011EC7 // arbitary tag
        eventsIdicatorTag = tag
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isUserInteractionEnabled = false //Used to pass touches to parent view, basically bug patch
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.tag = tag
        return collectionView
    }
    
    private func createEventsCountLabel() -> UILabel{
        let eventLabel = UILabel()
        let eventLabelTag = 0x1ABE1
        eventLabel.tag = eventLabelTag
        eventsIdicatorTag = eventLabelTag
        return eventLabel
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
        view.widthAnchor.constraint(equalTo: cell.contentView.widthAnchor, multiplier: 0.9).isActive = true
        
        cell.contentView.layoutIfNeeded()
        view.layer.cornerRadius = view.bounds.height / 2
        
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
