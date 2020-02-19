//
//  HourCell.swift
//  Time+
//
//  Created by Abdulhalim Rafeik on 1/28/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class HourCell: UITableViewCell {
    @IBOutlet var TopHalfViews : [UIView]!
    @IBOutlet var BottomHalfViews : [UIView]!

    @IBOutlet weak var AMPMLabel: UILabel!
    @IBOutlet weak var ClockImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
