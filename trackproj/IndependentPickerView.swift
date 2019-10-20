//
//  IndependentPickerView.swift
//  trackproj
//
//  Created by Danil on 11/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit


protocol IndependentPickerController: UIPickerViewDelegate, UIPickerViewDataSource{
    
}

class IndependentPickerView: UIVisualEffectView {
    
    
    var controller: IndependentPickerController? {
        set{
            pickerView.dataSource = newValue
            pickerView.delegate = newValue
        }
        get{
            return pickerView.dataSource as? IndependentPickerController
        }
    }
    
    
    var pickerView: UIPickerView = UIPickerView()
    
    init(frame: CGRect){
        super.init(effect: UIBlurEffect(style: .light))
        
        
        self.frame = frame
        
        self.clipsToBounds = true
        
        if #available(iOS 11.0, *) {
            self.layer.cornerRadius = 20
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            
            let maskPath = UIBezierPath(roundedRect: self.bounds,
                                        byRoundingCorners: [.topLeft, .topRight],
                                        cornerRadii: CGSize(width: 20.0, height: 20.0))
            let shape = CAShapeLayer()
            shape.path = maskPath.cgPath
            self.layer.mask = shape
            
        }
        
        let pickerView = UIPickerView(frame: self.bounds)
        self.pickerView = pickerView
        self.contentView.addSubview(pickerView)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
