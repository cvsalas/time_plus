//
//  helpScreenViewController.swift
//  Time+
//
//  Created by Roee Landesman on 2/3/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class helpScreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    let primaryIcons = MainIconsDataBase.sharedInstance.get()
    
    @IBOutlet weak var CollectionViewOutlet: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissLogo.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 30)!
        dismissLogo.setTitle("\u{f00d}", for: .normal)
        
    }
    @IBAction func dismissModal(_ sender: Any) {
        dismissSemiModalView()
    }
    
    @IBOutlet weak var dismissLogo: UIButton!
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return primaryIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! IconCollectionViewCell
        let iconCode = String(UnicodeScalar(Int(primaryIcons[indexPath.row][MainIconsDataBase.columns.icon]))!)
        let color =  UIColor(rgba: primaryIcons[indexPath.row][MainIconsDataBase.columns.color])
        cell.iconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 30)!
        cell.iconLabel.text = iconCode
        cell.backgroundColor = color
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 3
        let cellsAbove: CGFloat = 2
        let spaceBetweenCells: CGFloat = 1
        let width = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        let height = (collectionView.bounds.height - (cellsAbove - 1) * spaceBetweenCells) / cellsAbove
        return CGSize(width: width, height: height)
    }
}
