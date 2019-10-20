//
//  customRectButton.swift
//  trackproj
//
//  Created by Danil on 17/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit


@IBDesignable

class CustomRectButton: UIButton {
    
    @IBInspectable var lineWidth: CGFloat = 1.5
    @IBInspectable var rectRadius: CGFloat = 9
    
	
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		createBoundindRectangle().stroke()
	}
	
	
	func createBoundindRectangle() -> UIBezierPath {
		let roundedRect = UIBezierPath(
			roundedRect: self.bounds.insetBy(dx: 2, dy: 2),
			cornerRadius: rectRadius
		)
		
        roundedRect.lineWidth = lineWidth
        return roundedRect
        
    }

}
