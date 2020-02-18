//
//  IconsCollectionViewController.swift
//  
//
//  Created by user165037 on 2/18/20.
//

import UIKit
import Foundation

private let cellReuseIdentifier = "iconCell"
private let headerReuseIdentifier = "iconCell"

class IconsCollectionViewController: UICollectionViewController {

    typealias Icon = (name: String, code: UInt64)
    typealias Section = (name: String, icons: [Icon])
    
    var sections : [Section] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(IconCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        self.collectionView!.register(IconCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerReuseIdentifier)
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    func loadIcons(){
        if let path = Bundle.main.path(forResource: "Icons", ofType: "csv"){
            do{
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
                var section = Section(name: "", [])
                
                for line in lines.dropFirst() {
                    let components = line.components(separatedBy: ",")
                    if components.first!.range(of: "[A-Z]+", options: .regularExpression) != nil{
                        if !section.icons.isEmpty{
                            sections.append(section)
                        }
                        
                        section.name = components.first!
                    }
                    else{
                        assert(!section.name.isEmpty)
                        var hexCode : UInt64 = 0
                        let scanner = Scanner(string: components[2])
                        scanner.scanHexInt64(&hexCode)
                        section.icons.append(Icon(name: components[3], code: hexCode))
                    }
                }
            }catch {
                fatalError("Could not load file. \(error)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
