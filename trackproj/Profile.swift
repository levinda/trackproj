//
//  Profile.swift
//  trackproj
//
//  Created by Danil on 20/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import Foundation
import UIKit


class Profile{
	
	var profileImage: UIImage? = nil
	var favCategories = [String]()
	var name: String
	
	init(name: String) {
		self.name = name
	}
	
}
