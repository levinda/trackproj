//
//  showNewsSegue.swift
//  trackproj
//
//  Created by Danil on 01/12/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class showNewsSegue: UIStoryboardSegue {

	override func perform(){
		
		if let sourceVC = source as? NewsViewController, let destVC = destination as? DetailedStoryViewController{
			
			
			let transition = CATransition()
			transition.duration = 1
			transition.type = .fade
			
			
			var firstVCView = self.source.view as UIView
			var secondVCView = self.destination.view as UIView
			
			sourceVC.view.layer.add(transition, forKey: nil)
			
			sourceVC.present(destVC, animated: false, completion: nil)
			
		}
		
	
		
		
	}
	
		
}
