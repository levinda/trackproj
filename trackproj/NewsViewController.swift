//
//  ViewController.swift
//  trackproj
//
//  Created by Danil on 27/09/2019.
//  Copyright © 2019 levinda. All rights reserved.

import UIKit
import CoreData

class NewsViewController: UIViewController {
	
	// Fetched results controller
	
	lazy var frc: NSFetchedResultsController<NSFetchRequestResult> = constructFetcherForCategory(named: "Main")
    
    // MARK: Temporal Data
		
    let categories: [String] = ["Main", "Music", "Politics", "Space", "Cinema"]
	
	var currentSelectedCategory: (name: String, number: Int) = ("Main", 0){
		didSet{
			frc = constructFetcherForCategory(named: currentSelectedCategory.name)
			
		}
	}
	
	var articles: [ArticleAPI] = []
	var images: [String: UIImage] = [ : ]
    
	
	
	
	// MARK: Properties
	
	var pickerViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(processTapGesture))
	
    // MARK: Outlets
    
    @IBOutlet weak var categoryBar: CustomBarView!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var pickerView: IndependentPickerView?
    
    
    //MARK: Actions
	
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
	
		if pickerView != nil{
            dismissPicker()
        }
        else{
            let picker = IndependentPickerView(
                frame: CGRect(
                    x: 0, y: self.view.bounds.height * 2/3,
                    width: view.bounds.width,
                    height: view.bounds.height / 3
                )
            )
			
			let pickerViewTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(processTapGesture))
			self.view.addGestureRecognizer(pickerViewTapGestureRecognizer)
			self.pickerViewTapGestureRecognizer = pickerViewTapGestureRecognizer
			
			
			let pickerViewPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(processPanGesture))
			
			picker.addGestureRecognizer(pickerViewPanGestureRecognizer)
	
            picker.controller = self
            picker.pickerView.selectRow(currentSelectedCategory.number, inComponent: 0, animated: false)
            self.view.addSubview(picker)
            pickerView = picker
        }
    }
	
	
	@objc func processTapGesture(_ recognizer: UITapGestureRecognizer){
		switch recognizer.state{
		case .ended:
			// Checking whether the touch is outside the Picker View
			if !(pickerView?.point(inside: recognizer.location(in: pickerView), with: .none) ?? true){
				dismissPicker()
			}
		default:
			break
		}
	}
    
	
	@objc func processPanGesture(_ recognizer: UIPanGestureRecognizer){
		switch recognizer.state{
		case .changed:
			print(recognizer.translation(in: self.view))
		default: break
		}
	}
	
	func dismissPicker(){
			pickerView!.removeFromSuperview()
			pickerView = nil
			self.view.removeGestureRecognizer(pickerViewTapGestureRecognizer)
	}
	
	
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		downloadNewsFor(category: "Main", page: 1)
		
    }
    
    override func viewDidLayoutSubviews() {
        tableView.setNeedsLayout()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStory" {
            if let newsCell = sender as? UITableViewCell, let index = tableView.indexPath(for: newsCell){
                if let destinationVC = segue.destination as? DetailedStoryViewController{
					
					let article = articles[index.row]
					destinationVC.mainText = article.content
					destinationVC.mainImage = images[article.url] ?? UIImage(named: "roundedrect.png")
					destinationVC.title = article.title
					
					
				}
			}
		}
		if segue.identifier == "showProfileEditor" {
			if let destVC = segue.destination as? ProfileViewController {
				destVC.categories = self.categories
			}
		}
	}
	
	
	//MARK: WebServices Realisation
	
	func downloadNewsFor(category: String, page: Int){
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = "newsapi.org"
		components.path = "/v2/everything"
		
		
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM"
		
		let formattedDate = formatter.string(from:date)
		
		print(formattedDate)
		components.queryItems = [
			URLQueryItem(name: "q", value: category),
	//		URLQueryItem(name: "from", value: formattedDate),
			URLQueryItem(name: "pageSize", value: "\(updateParameters.pageSize)"),
			URLQueryItem(name: "language", value: "ru"),
			URLQueryItem(name: "page", value:"\(page)"),
			URLQueryItem(name: "sortBy", value: "publishedAt"),
			URLQueryItem(name: "apiKey", value: "e5ad458bf2844b628f5e593e7edd1e96")
		]
		
		guard let url = components.url else {return}
		
		let request = URLRequest(url: url)
		let newTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
			do {
				if let data = data{
					let articles = try JSONDecoder().decode(newsApiData.self, from: data).articles
					
					self.articles += articles
					
					DispatchQueue.main.async { [weak self] in
						self?.tableView.reloadData()
					}
					
					for (number, article) in articles.enumerated(){
						if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
							let downloadTask = URLSession.shared.dataTask(with: url) { (imageData, resp, error) in
								if let data = imageData, let image = UIImage(data: data){
									self.images[article.url] = image
								}
							}
							downloadTask.resume()
						}
					}
				}
			}catch{
				print(error)
			}
		}
		newTask.resume()
	}
	
	// MARK: Core Data
	
	
	func saveApiArticlesToCoreData(aricles: [ArticleAPI]){
		
	}
	
	func constructFetcherForCategory(named category: String) -> NSFetchedResultsController<NSFetchRequestResult>{
		
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let newsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
		newsFetchRequest.predicate = NSPredicate(format: "category == %@", category)
		let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
		newsFetchRequest.sortDescriptors = [sortDescriptor]
		newsFetchRequest.propertiesToFetch = ["title","publlishedAt","imageData", "content"]
		
		let frc = NSFetchedResultsController(fetchRequest: newsFetchRequest,
											 managedObjectContext: delegate.managedObjectContext,
											 sectionNameKeyPath: nil,
											 cacheName: nil)
		return frc
	}
	
}



extension NewsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = frc.sections else {
			return 0
		}
		let currentSection = sections[section]
		return currentSection.numberOfObjects
    }
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 310
	}
		
    // Отрисовка ячейки
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard articles.count > 0 else {
			if let basicCell = tableView.dequeueReusableCell(withIdentifier: "mainNewsCell", for: indexPath) as? NewsTableViewCell{
				return basicCell
			}
			return UITableViewCell()
		}
		
		
		let article = articles[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "mainNewsCell", for: indexPath)
		if let newsCell = cell as? NewsTableViewCell {
			newsCell.titleLabel.text = article.title
			newsCell.newsImageView.image = images[article.url] ?? UIImage(named: "roundedrect.png")
			newsCell.setNeedsDisplay()
			return newsCell
		}
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "newsNoImageCell"){
			cell.textLabel?.text = article.title
			return cell
		}
		return UITableViewCell()
    }
    
}


// MARK: IndependentPickerViewController
extension NewsViewController: IndependentPickerViewController{
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		images = [:]
		articles = []
        categoryButton.setTitle(categories[row], for: .normal)
        currentSelectedCategory = (categories[row], row)
		downloadNewsFor(category: categories[row], page: 1)
		
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
}

// MARK: NSFetchedResultsControllerDelegate

extension NewsViewController: NSFetchedResultsControllerDelegate{
	
	
	
}


// Mark: Constants

struct updateParameters{
	static var pageSize: Int = 30
}

