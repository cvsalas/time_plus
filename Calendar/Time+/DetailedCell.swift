//
//  DetailedCell.swift
//  Time+
//
//  Created by user165037 on 2/8/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class DetailedCell: UITableViewCell {

    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var iconeTitle: UILabel!
    @IBOutlet weak var detailedInfo: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
