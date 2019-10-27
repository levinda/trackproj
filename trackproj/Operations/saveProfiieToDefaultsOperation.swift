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
	
	
	
	let profile: Profile
	
	
	
	init(profile: Profile ) {
		self.profile = profile
		super.init()
		
		
	}
	
	func saveProfileToDefaults(){
		
		let defaults: UserDefaults = UserDefaults()
		
		defaults.set(profile.name, forKey: "profileName")
		if let profileImage = profile.profileImage{
			defaults.set(profileImage.pngData(), forKey: "profileImage")
			
		}
		
	}
		
	
	override func main(){
		saveProfileToDefaults()
	}
}
