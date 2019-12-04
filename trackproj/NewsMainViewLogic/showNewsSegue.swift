//
//  showNewsSegue.swift
//  trackproj
//
//  Created by Danil on 01/12/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class showNewsSegue: UIStoryboardSegue {
	
	var tableCell: NewsTableViewCell?
	
	//var senderViewCell
	
	override func perform(){
		
		if let sourceVC = source as? NewsViewController, let destVC = destination as? DetailedStoryViewController, let newsCell = tableCell{
						
			let initialCellPosition = newsCell.frame
			
			UIView.animate(withDuration: 0.3, animations: {
				newsCell.frame = newsCell.frame.offsetBy(dx: 0, dy: 1000)
			}) { (bool) in
				sourceVC.present(destVC, animated: true)
				UIView.animate(withDuration: 0.3, animations: {
					newsCell.frame = initialCellPosition
				})
			}
		}
		
	
		
		
	}
	
		
}
