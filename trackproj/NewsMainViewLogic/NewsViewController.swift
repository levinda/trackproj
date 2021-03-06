//
//  ViewController.swift
//  trackproj
//
//  Created by Danil on 27/09/2019.
//  Copyright © 2019 levinda. All rights reserved.

import UIKit
import CoreData


class NewsViewController: UIViewController {
	
	// TODO: Limit fetchBatchSize, entity
	
	// Fetched results controller
	
	lazy var frc: NSFetchedResultsController<NSFetchRequestResult> = constructFetcherForCategory(named: "Main")
	
	// MARK: Temporal Data
	
	let categories: [String] = ["Main", "Music", "Politics", "Space", "Cinema"]
	
	var currentSelectedCategory: (name: String, number: Int) = ("Main", 0){
		didSet{
			frc = constructFetcherForCategory(named: currentSelectedCategory.name)
			try? frc.performFetch()
			frc.delegate = self
			
			downloadNewsFor(category: currentSelectedCategory.name, page: 1)
			
			self.tableView.reloadData()
			
		}
	}
	
	let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
		formatter.timeZone = TimeZone(secondsFromGMT: 0)
		return formatter
	}()
	
	
	
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
					x: 0, y: self.view.bounds.height,
					width: view.bounds.width,
					height: view.bounds.height / 3
				)
			)
			
			let bounds = self.view.bounds
			UIView.animate(withDuration: 0.5) {
				picker.frame = CGRect(x: 0, y: bounds.height * 2/3, width: bounds.width, height: bounds.height / 3)
			}
			
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
		frc.delegate = self
		// downloadNewsFor(category: "Main", page: 1)
		
		try? frc.performFetch()
		
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
		
		if #available(iOS 10.0, *) {
			tableView.refreshControl = refreshControl
		} else {
			tableView.backgroundView = refreshControl
		}
		
		NotificationCenter.default.addObserver(self, selector: #selector(interfaceStyleDidChange), name: NSNotification.Name(rawValue: "traitInterfaceStyleDidChange"), object: nil)

		
	}
	
	override func viewDidLayoutSubviews() {
		tableView.setNeedsLayout()
	}
	
	// MARK: Navigation
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showStory"{
			if let newsCell = sender as? NewsTableViewCell, let index = tableView.indexPath(for: newsCell), let newsSegue = segue as? showNewsSegue{
				newsSegue.tableCell = newsCell
				if let destinationVC = segue.destination as? DetailedStoryViewController{
					
					if let article = frc.object(at: index) as? Article {
						destinationVC.mainText = article.content
						destinationVC.title = article.title
						if let data = article.imageData{
							destinationVC.mainImage = UIImage(data: data)
						}
					}
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
		
		
		let latestNewsDateString = getLatestDateForNewsCategory(category: category)
		
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = "newsapi.org"
		components.path = "/v2/everything"
		
		components.queryItems = [
			URLQueryItem(name: "q", value: category),
			URLQueryItem(name: "pageSize", value: "\(updateParameters.pageSize)"),
			URLQueryItem(name: "from", value: latestNewsDateString ?? ""),
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
					
					DispatchQueue.main.async { [weak self] in
						self?.tableView.reloadData()
					}
					
					for (_, article) in articles.enumerated(){
						if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
							let downloadTask = URLSession.shared.dataTask(with: url) { (imageData, resp, error) in
								if let data = imageData, let _ = UIImage(data: data){
									DispatchQueue.main.async { [weak self] in
										self?.saveApiArticleToCoreData(article: article, withImageData: data, andCategory: category)
									}
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
	
	@objc func refresh(_ refreshControl: UIRefreshControl) {
		
		downloadNewsFor(category: currentSelectedCategory.name, page: 1)
		
		refreshControl.endRefreshing()
	}
	
	
	
	
	// MARK: Core Data
	
	
	func saveApiArticleToCoreData(article: ArticleAPI, withImageData imageData: Data, andCategory category: String){
		
		guard let delegate = UIApplication.shared.delegate as? AppDelegate else
		{
			return
		}
		if let articleTypeEntity = NSEntityDescription.entity(forEntityName: "Article", in: delegate.managedObjectContext){
			
			let modelArticle = Article(entity: articleTypeEntity, insertInto: delegate.managedObjectContext)
			
			modelArticle.title = article.title
			modelArticle.content = article.content
			print(article.publishedAt)
			modelArticle.publishedAt = convertToDate(stringDate: article.publishedAt)
			modelArticle.source = article.url
			
			modelArticle.category = category
			modelArticle.imageData = imageData
			
			delegate.saveContext()
		}
	}
	
	func constructFetcherForCategory(named category: String) -> NSFetchedResultsController<NSFetchRequestResult>{
		
		let delegate = UIApplication.shared.delegate as! AppDelegate
		let newsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
		newsFetchRequest.predicate = NSPredicate(format: "category == %@", category)
		let sortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: false)
		newsFetchRequest.sortDescriptors = [sortDescriptor]
		newsFetchRequest.propertiesToFetch = ["title","publishedAt","imageData", "content"]
		
		let frc = NSFetchedResultsController(fetchRequest: newsFetchRequest,
											 managedObjectContext: delegate.managedObjectContext,
											 sectionNameKeyPath: nil,
											 cacheName: nil)
		return frc
	}
	
	
	func getLatestDateForNewsCategory(category: String) -> String? {
		
		let delegate = UIApplication.shared.delegate as! AppDelegate
		
		let newsFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Article")
		newsFetchRequest.predicate = NSPredicate(format: "category == %@", category)
		newsFetchRequest.fetchLimit = 1
		
		let sortDescriptor = NSSortDescriptor(key: "publishedAt", ascending: false)
		newsFetchRequest.sortDescriptors = [sortDescriptor]
		newsFetchRequest.propertiesToFetch = ["publishedAt"]
		
		let frc = NSFetchedResultsController(fetchRequest: newsFetchRequest,
											 managedObjectContext: delegate.managedObjectContext,
											 sectionNameKeyPath: nil,
											 cacheName: nil)
		
		
		do {
			try frc.performFetch()
		

			if let result = frc.fetchedObjects?.first as? Article{
				if let date = result.publishedAt{
					let latestDatePlus1Sec = date.timeIntervalSince1970 + 1
					let dateToReturn = Date(timeIntervalSince1970: latestDatePlus1Sec)
					return converToString(date: dateToReturn)
				}
			}
			
			
			
		}catch{
			print(error)
		}
		
		return nil
	}
	
	//MARK: Notifications Handlers
	
	@objc func interfaceStyleDidChange(){
		
	}
		
	
	// MARK: Utillities
	
	func convertToDate(stringDate: String) -> Date? {
		let date = formatter.date(from: stringDate)
		return date
	}
	
	func converToString(date: Date) -> String{
		return formatter.string(from: date)
	}

}


// MARK: NewsTableViewController
extension NewsViewController: UITableViewDataSource,UITableViewDelegate{
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let sections = frc.sections else {
			return 0
		}
		let currentSection = sections[section]
		print(currentSection.numberOfObjects)
		return currentSection.numberOfObjects
	}
	
	
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 310
	}
	
	// Отрисовка ячейки
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainNewsCell") as? NewsTableViewCell,
			let article = frc.object(at: indexPath) as? Article else {
				return UITableViewCell()
		}
		cell.titleLabel.text = article.title
		cell.newsImageView.image = UIImage(data: article.imageData ?? Data()) ?? UIImage(named: "roundedrect.png")
		
		return cell
		
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
		
		categoryButton.setTitle(categories[row], for: .normal)
		currentSelectedCategory = (categories[row], row)
	}
	
	func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
		return 32
	}
	
}

// MARK: NSFetchedResultsControllerDelegate

extension NewsViewController: NSFetchedResultsControllerDelegate{
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
					didChange anObject: Any,
					at indexPath: IndexPath?,
					for type: NSFetchedResultsChangeType,
					newIndexPath: IndexPath?) {
		tableView.beginUpdates()
		switch type
		{
		case .insert:
			tableView.insertRows(at: [newIndexPath!], with: .automatic)
		case .move:
			tableView.deleteRows(at: [indexPath!], with: .automatic)
			tableView.insertRows(at: [newIndexPath!], with: .automatic)
		case .update:
			tableView.reloadRows(at: [indexPath!], with: .automatic)
		case .delete:
			tableView.deleteRows(at: [indexPath!], with: .automatic)
		default:
			break
		}
		tableView.endUpdates()
	}

}


// Mark: Constants

private enum updateParameters{
	static var pageSize: Int = 50
}

