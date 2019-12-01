//
//  LabeledPictureView.swift
//  trackproj
//
//  Created by Danil on 07/11/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class LabeledPictureView: UIView {
	
	
	
	weak var textLabel: UILabel!
	weak var newsImageView: UIImageView!
	
	lazy var needsGradient = {
		return self.textLabel.text != nil
	}
	
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	
	func createLabel(){
			
	}
	
	func frameForLabel() -> CGRect{
		return CGRect()
	}
	
	
	func setLabelTitile(_ title: String){
		if let label = textLabel{
			label.text = title
		}else{
			createLabel()
			textLabel.text = title
		}
	}
	
	func gradeImageView(){
		
		newsImageView.layer.sublayers = []
		let gradient = CAGradientLayer()
		self.frame = newsImageView.bounds
		gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
		gradient.locations = [0.6,1]
		
	}

}
