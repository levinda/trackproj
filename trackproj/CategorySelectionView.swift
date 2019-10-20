//
//  CategorySelectionView.swift
//  trackproj
//
//  Created by Danil on 21/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class CategorySelectionView: UIView {

	
	weak var tableView: UITableView!
		
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		let effectedView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
		effectedView.frame = self.bounds
		self.addSubview(effectedView)
		
		let dismissButton = UIButton(frame: CGRect(x: bounds.midX - 15, y: 20, width: 30, height: 10))
		dismissButton.setImage( UIImage(named: "DownArrow.png"), for: .normal)
		dismissButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
		
		let label = UILabel(frame: CGRect(x: bounds.midX - 40, y: 40, width: 100, height: 50))
		label.text = "Categories"
		
		self.addSubview(dismissButton)
		self.addSubview(label)
		
		let tableView = UITableView(frame: CGRect(x: 0, y: 90, width: self.bounds.width, height: self.bounds.height - 90), style: .plain)
	}
	
	
	@objc func dismiss(_ button: UIButton){
		self.removeFromSuperview()
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
