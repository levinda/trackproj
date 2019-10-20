//
//  ProfileViewController.swift
//  trackproj
//
//  Created by Danil on 18/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit
import Foundation
import Photos


class ProfileViewController: UIViewController {
	
	
	let categories: [String] = ["Main News","Favorites", "Music", "Politics", "Crime", "Hot"]
	
	
	// MARK: Outlets
	
	
	@IBOutlet weak var profileImageView: UIImageView!{
		didSet{
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnProfilePicture))
			tapGestureRecognizer.numberOfTouchesRequired = 1
			profileImageView.addGestureRecognizer(tapGestureRecognizer)
		}
	}
	
	
	@IBOutlet weak var nameTextField: UITextField!
	
	
	
	// MARK: Actions
	
	@IBAction func enteredName(_ sender: UITextField) {
	}
	
	
	@IBAction func selectCategories(_ sender: UIButton) {
		let catSelector = CategorySelectionView(frame: self.view.bounds)
		self.view.addSubview(catSelector)
	}
	
	
	@IBAction func saveGCD(_ sender: UIButton) {
		
		let queue = DispatchQueue.global(qos: .default)
		
		let indicator = UIActivityIndicatorView(frame: getRectForIndicator())
		indicator.startAnimating()
		self.view.addSubview(indicator)
		
		queue.async {
			self.saveProfileToDefaults()
			DispatchQueue.main.async {
				indicator.stopAnimating()
				self.dismiss(animated: true, completion: nil)
			}
		}
		
	
	}
	
	
	@IBAction func saveNSOperation(_ sender: UIButton) {
		
			guard let name = profileName else{
				print("")
				return
			}
			
			let savingOperation = saveProfileToNSDefaultsOperation(name: name, categories: [], image: profileImage)
			
			let operationQueue = OperationQueue()
		
			operationQueue.addOperation(savingOperation)
			
	}
	
	
	// MARK: Handlers
	
	@objc func handleTapOnProfilePicture(recognizer: UITapGestureRecognizer){
		switch recognizer.state{
		case .ended:
			let imagePickerViewController = UIImagePickerController()
			imagePickerViewController.delegate = self
			present(imagePickerViewController, animated: true)
		default:
			print("ProfileImageRecognizer: State dif from ended")
		}
	}
	
	
	//MARK: Properties
	
	var profileName: String? = nil
	var profileImage: UIImage? = nil
	
	var favCategories: [String] = []
	
	var profile: Profile? = nil
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Delegation:
		nameTextField.delegate = self
		
		
		// Look adjustment:
		profileImageView.layer.cornerRadius = 20
		
		extractProfileFromDefaults()
	
	}
	
	
	func extractProfileFromDefaults(){
		
		let defaults: UserDefaults = UserDefaults()
		
		let imageData = defaults.data(forKey: "profileImage")
	
		var image: UIImage? = nil
		
		if let data = imageData{
			image = UIImage(data: data)
		}
		
		profileImageView.image = image
		profileImage = image
		
		let name = defaults.string(forKey: "profileName")
		nameTextField.text = name
		self.profileName = name
	
		
		
		
//		var profile: Profile! = nil
//		if let realName = name{
//			profile = Profile(name: realName)
//			profile.profileImage = image
//
//			// TODO: Categories
//			profile.favCategories = []
//		}
//
		
		
	}
	
	
	func saveProfileToDefaults(){
		
		let defaults: UserDefaults = UserDefaults()
		
		defaults.set(profileImage?.pngData(), forKey: "profileImage")
		defaults.set(profileName, forKey: "profileName")
		
	}
	
	
	func getRectForIndicator() -> CGRect{
		let y: CGFloat = self.view.bounds.maxY - 100
		let x: CGFloat = self.view.bounds.midX - 20
		return CGRect(x: x, y: y, width: 40, height: 40)
	}
	
	
	
	func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            print("User do not have access to photo album.")
        case .denied:
            print("User has denied the permission.")
		@unknown default:
			fatalError()
		}
    }
	
	
	
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if let image = info[.originalImage] as? UIImage {
			profileImageView.image = image
			self.profileImage = image
		}
		
		picker.dismiss(animated: true, completion: nil)
	}
}


extension ProfileViewController: UITextFieldDelegate{
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		profileName = nameTextField.text
		
		
		return true
	}
	
}

