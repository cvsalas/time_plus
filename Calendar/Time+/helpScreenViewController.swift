//
//  helpScreenViewController.swift
//  Time+
//
//  Created by Roee Landesman on 2/3/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class helpScreenViewController: UIViewController, UICollectionViewDataSource{
    
    @IBOutlet weak var CollectionViewOutlet: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "faqCell", for: indexPath) as! FAQCollectionViewCell
        let iconTitles: [String] = ["\u{f00d}","\u{f00d}","\u{f00d}","\u{f00d}","\u{f00d}","\u{f00d}","\u{f00d}"]
        cell.iconLabel.text = iconTitles[indexPath.row]
        cell.iconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 30)!
        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        dismissLogo.titleLabel?.font = UIFont(name: "FontAwesome5Free-Solid", size: 30)!
        dismissLogo.setTitle("\u{f00d}", for: .normal)
    }
    @IBAction func dismissModal(_ sender: Any) {
        dismissSemiModalView()
    }
    
    @IBOutlet weak var dismissLogo: UIButton!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
