//
//  FAQCollectionViewCell.swift
//  Time+
//
//  Created by Roee Landesman on 2/28/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class FAQCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconLabel: UILabel!
    
    func displayContent(text: String){
        iconLabel.text = text
    }
}
