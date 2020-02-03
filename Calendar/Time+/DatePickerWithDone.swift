//
//  DatePickerWithDone.swift
//  Time+
//
//  Created by user165037 on 2/1/20.
//  Copyright © 2020 LibLabs-Mac. All rights reserved.
//

import UIKit

protocol DatePickerWithDoneDelegate{
    func doneTapped()
}
class DatePickerWithDone: UIView {
    
    private let toolBarRelativeHeight: CGFloat = 0.20
    private let pickerRelativeHeight: CGFloat = 0.80
    private let toolbar = UIToolbar()
    private let datePicker = UIDatePicker()

    
    var delegate : DatePickerWithDoneDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup(){
        self.autoresizesSubviews = true
        self.backgroundColor = .white
        toolbar.frame = CGRect(x:0, y:0, width: self.frame.size.width, height: self.frame.size.height*toolBarRelativeHeight)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneTapped))
        
        toolbar.setItems([doneButton], animated: true)
        toolbar.isUserInteractionEnabled = true
        toolbar.autoresizingMask = [.flexibleBottomMargin, .flexibleWidth]
        addSubview(toolbar)
        
        datePicker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        datePicker.frame = CGRect(x:0, y: self.frame.size.height*toolBarRelativeHeight, width: self.frame.size.width, height: self.frame.size.height*pickerRelativeHeight)
        
        addSubview(datePicker)
    }
    
    @objc func doneTapped(){
        self.backgroundColor = .blue
        self.delegate?.doneTapped()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
