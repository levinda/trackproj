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

	// Temporal Data
	
	let categories: [String] = ["Main", "Music", "Politics", "Crime", "Hot"]
	var selectedIndexes = Set<IndexPath>()
	
	
	//MARK: Properties
	
	var profile: Profile = Profile()
	
	
	// MARK: Outlets
	
	
	
	
	@IBOutlet weak var profileImageView: UIImageView!{
		didSet{
			let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapOnProfilePicture))
			tapGestureRecognizer.numberOfTouchesRequired = 1
			profileImageView.addGestureRecognizer(tapGestureRecognizer)
		}
	}
	
	
	@IBOutlet weak var favCategoriesLabel: UILabel!
	
	
	@IBOutlet weak var nameTextField: UITextField!
	
	
	
	// MARK: Actions
		
	
	@IBAction func selectCategories(_ sender: UIButton) {
		
		let catSelector = CategorySelectionView(frame: self.view.bounds.divided(atDistance: 100, from: .minYEdge).remainder)
		self.view.addSubview(catSelector)
		
		catSelector.selectedRows = selectedIndexes
		catSelector.setDataSource(self)
		catSelector.setDelegate(self)
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
			
		let savingOperation = saveProfileToNSDefaultsOperation(profile: profile)
			
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
	
	
	
	// Coversion Function
	
	func getCategoriesForIndexPaths(_ indexes: Set<IndexPath>) -> [Category]{
		var retCategories = [Category]()
		for index in indexes{
			let category = Category(name: categories[index.row])
			retCategories.append(category)
		}
		return retCategories
	}
	
	func getIndexesForCategories(_ categories: [Category]) -> Set<IndexPath>{
		
		var indexSet = Set<IndexPath>()
		for category in categories{
			if let rowIndex = self.categories.firstIndex(of: category.name){
				indexSet.insert(IndexPath(row: rowIndex, section: 0))
			}
		}
		
		return indexSet
	}
	

	
	
    override func viewDidLoad() {
        super.viewDidLoad()
		// Delegation:
		nameTextField.delegate = self
		
		
		// Look adjustment:
		profileImageView.layer.cornerRadius = 20
		
		profile = extractProfileFromDefaults()
		
		updateUIFromModel()
	
	}
	
	
	func updateUIFromModel(){
		
		profileImageView.image = profile.profileImage
		nameTextField.text = profile.name
		favCategoriesLabel.text = "Favorite categories: \(selectedIndexes.count) selected"
	}
	
	
	func extractProfileFromDefaults() -> Profile{
		
		let defaults: UserDefaults = UserDefaults()
		
		let constructedProfile = Profile()
		
		let name = defaults.string(forKey: "profileName")
		
		constructedProfile.name = name
	
		// Getting image
		if let data = defaults.data(forKey: "profileImage"){
			if let image = UIImage(data: data){
				constructedProfile.profileImage = image
			}
		}
		
		if let loadedCategoriesNames = defaults.stringArray(forKey: "favCategories"){
			let loadedCategories = loadedCategoriesNames.map {return Category(name: $0)}
			constructedProfile.favCategories = loadedCategories
			self.selectedIndexes = getIndexesForCategories(loadedCategories)
		}
		
		
		return constructedProfile
		
	}
	
	
	func saveProfileToDefaults(){
	
		let defaults: UserDefaults = UserDefaults()
			
		defaults.set(profile.name, forKey: "profileName")
		if let profileImage = profile.profileImage{
			defaults.set(profileImage.pngData(), forKey: "profileImage")
		}
		defaults.set(profile.favCategories?.map{ return $0.name}, forKey: "favCategories")
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
			self.profile.profileImage = image
		}
		
		picker.dismiss(animated: true, completion: nil)
	}
}


extension ProfileViewController: UITextFieldDelegate{
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		
		textField.resignFirstResponder()
		self.profile.name = textField.text
		
		
		return true
	}
	
}

extension ProfileViewController: CategorySelectionViewDataSource{
	
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return categories.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let categoryCell = tableView.dequeueReusableCell(withIdentifier: "categoryCell") as? CategoryTableViewCell{
			categoryCell.categoryLabel.text = categories[indexPath.row]
			categoryCell.tickImageView.isHidden = !selectedIndexes.contains(indexPath)
			return categoryCell
		}
		return UITableViewCell()
	}
	
}


extension ProfileViewController: CategorySelectionViewDelegate{
	
	func categorySelectionView(_ view: CategorySelectionView, didFinishSelectingWithSelectedRows indexPaths: Set<IndexPath>){
		selectedIndexes = indexPaths
		
		self.profile.favCategories = getCategoriesForIndexPaths(indexPaths)
		updateUIFromModel()
	}
	
	
}
