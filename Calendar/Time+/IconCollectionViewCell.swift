//
//  IconCollectionViewCell.swift
//  Time+
//
//  Created by user165037 on 2/17/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var iconLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override var isSelected: Bool {
        didSet{
            if self.isSelected {
                self.layer.borderWidth = 10
            }
            else {
                self.layer.borderWidth = 0
            }
        }
    }
    

    
}

