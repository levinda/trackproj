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
	var completionHandler: (() -> Void)? = nil
	
	
	
	init(profile: Profile, completionHandler: (() -> Void)?) {
		self.profile = profile
		self.completionHandler = completionHandler
		super.init()
		
	}
	
	func saveProfileToDefaults(){
		
		defaults.set(profile.name, forKey: "profileName")
		if let profileImage = profile.profileImage{
			defaults.set(profileImage.pngData(), forKey: "profileImage")
		}
		defaults.set(profile.favCategories?.map{ return $0.name}, forKey: "favCategories")
	}
	
	
	override func main(){
		saveProfileToDefaults()
		if let handler = completionHandler{
			DispatchQueue.main.async(execute: handler)
		}
	}
}
