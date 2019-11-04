//
//  CustomBarView.swift
//  trackproj
//
//  Created by Danil on 09/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class CustomBarView: UIVisualEffectView {
	
	
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        isOpaque = false
        effect = UIBlurEffect(style: .light)
        backgroundColor = .clear
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    

}
