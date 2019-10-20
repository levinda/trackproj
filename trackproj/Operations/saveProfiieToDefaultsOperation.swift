//
//  saveProfiieToDefaultsOperation.swift
//  trackproj
//
//  Created by Danil on 20/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import Foundation
import UIKit


class saveProfileToNSDefaultsOperation: BasicUserDefaultsOperation {
	
	
	
	let profileName: String
	let profileImage: UIImage?
	let favCategories: [String]
	
	
	
	init(name: String, categories: [String], image: UIImage? ) {
		profileName = name
		profileImage = image
		favCategories = categories
		super.init()
		
		
	}
	
	func saveProfileToDefaults(){
		
		defaults.set(profileImage?.pngData(), forKey: "profileImage")
		defaults.set(profileName, forKey: "profileName")
		
	}
	
	override func main(){
		saveProfileToDefaults()
	}
}
