//
//  IconsCollectionViewController.swift
//  
//
//  Created by user165037 on 2/18/20.
//

import UIKit
import Foundation

private let cellReuseIdentifier = "iconCell"
private let headerReuseIdentifier = "catHeader"

class IconsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    typealias Section = (catIcon: Icon, icons: [Icon])
    
    var sections : [Section] = []
    var iconSelected : ((IconCollectionViewCell) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        loadIcons()
        
        // Do any additional setup after loading the view.
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let tappedCell = collectionView.cellForItem(at:indexPath) as! IconCollectionViewCell
                
        iconSelected(tappedCell)
        navigationController?.popViewController(animated: true)
    }
    
    
    func loadIcons(){
        let path = Bundle.main.path(forResource: "Icons", ofType: "csv")!
        
        do{
            let data = try String(contentsOfFile: path, encoding: .utf8)
            let lines = data.components(separatedBy: .newlines)
            var section = Section(catIcon: Icon(name: "", code: "0"), icons: [])
            
            for line in lines.dropFirst() {
                let components = line.components(separatedBy: ",")
                if components.first!.range(of: "[A-Z]+", options: .regularExpression) != nil{
                    if !section.icons.isEmpty{
                        sections.append(section)
                        section = Section(catIcon: Icon(name: "", code: "0"), icons: [])
                    }
                    
                    section.catIcon = Icon(name: components.first!, code: UnicodeScalar("0"))
                }
                else if !components.first!.isEmpty{
                    assert(!section.catIcon.name.isEmpty)
                    let hexCode = UnicodeScalar(UInt32(components[1], radix: 16)!)!
                    section.icons.append(Icon(name: components[2], code: hexCode))
                }
            }
        }catch {
            fatalError("Could not load file. \(error)")
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
        return sections.count
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return sections[section].icons.count
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerReuseIdentifier, for: indexPath) as! IconCollectionReusableView
        header.iconLabel.text = String(sections[indexPath.section].catIcon.code)
        header.nameLabel.text = sections[indexPath.section].catIcon.name
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross: CGFloat = 3
        let spaceBetweenCells: CGFloat = 1
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: dim, height: dim)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! IconCollectionViewCell
        let section = sections[indexPath.section]
        let iconIndx = indexPath.row
        let hexCode = section.icons[iconIndx].code
        let name = section.icons[iconIndx].name
        
        cell.iconLabel.text = String(hexCode)

        cell.nameLabel.text = name
        
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
