//
//  BasicUserDefaultsOperation.swift
//  trackproj
//
//  Created by Danil on 20/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import Foundation

class BasicUserDefaultsOperation: Operation {
	
	
	
	let defaults: UserDefaults
	
	override init() {
		
		defaults = UserDefaults()
		
		super.init()
	
		
	}
}
