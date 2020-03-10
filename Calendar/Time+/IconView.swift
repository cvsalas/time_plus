//
//  IconView.swift
//  Time+
//
//  Created by user165037 on 2/18/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

class IconView: UIView {
    
    
    var icon = Icon(name: "", code: UnicodeScalar("0"))
    let iconLabel = UILabel()
    let nameLabel = UILabel()
    
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    convenience init(icon: Icon, frame: CGRect = .zero){
        self.init(frame: frame)
        setup(icon: icon)
    }
    
    func setup(icon: Icon){
        self.translatesAutoresizingMaskIntoConstraints = false
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 100)
        iconLabel.text = String(icon.code)
        iconLabel.textAlignment = .center
        iconLabel.numberOfLines = 0
        iconLabel.adjustsFontSizeToFitWidth = true
        iconLabel.minimumScaleFactor = .leastNonzeroMagnitude
        iconLabel.lineBreakMode = .byClipping
        addSubview(iconLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: "FontAwesome5Free-Solid", size: 100)
        nameLabel.text = icon.name
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = .leastNonzeroMagnitude
        nameLabel.lineBreakMode = .byClipping
        addSubview(nameLabel)
        
        iconLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 2).isActive = true
        iconLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        iconLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.4).isActive = true
        iconLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: iconLabel.bottomAnchor, constant: 1).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.35).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
