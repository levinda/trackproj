//
//  ViewController.swift
//  trackproj
//
//  Created by Danil on 27/09/2019.
//  Copyright © 2019 levinda. All rights reserved.

import UIKit

class NewsViewController: UIViewController {
    
    // MARK: Temporal Data
		
    let categories: [String] = ["Main","Favorites", "Music", "Politics", "Crime", "Hot"]
	var currentSelectedCategory: (name: String, number: Int) = ("Main", 0)
	
	var articles: [Article] = []
	var images: [String: UIImage] = [ : ]
    
    // MARK: Outlets
    
    @IBOutlet weak var categoryBar: CustomBarView!
    
    @IBOutlet weak var categoryButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var pickerView: IndependentPickerView?
    
    
    //MARK: Actions
    
    
    @IBAction func categoryButtonPressed(_ sender: UIButton) {
        if let picker = pickerView{
            picker.removeFromSuperview()
            pickerView = nil
        }
        else{
            let picker = IndependentPickerView(
                frame: CGRect(
                    x: 0, y: self.view.bounds.height * 2/3,
                    width: view.bounds.width,
                    height: view.bounds.height / 3
                )
            )
			
            
            picker.controller = self
            picker.pickerView.selectRow(currentSelectedCategory.number, inComponent: 0, animated: false)
            self.view.addSubview(picker)
            pickerView = picker
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
		downloadNewsForCategory("Main")
		
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
					destinationVC.mainImage = images[article.url]
				}
			}
		}
	}
	
	
	//MARK: WebServices Realisation
	
	func downloadNewsForCategory(_ category: String){
		
		var components = URLComponents()
		components.scheme = "https"
		components.host = "newsapi.org"
		components.path = "/v2/everything"
		components.queryItems = [
			URLQueryItem(name: "q", value: category),
			URLQueryItem(name: "from", value: "2019-10-03"),
			URLQueryItem(name: "sortBy", value: "publishedAt"),
			URLQueryItem(name: "apiKey", value: "e5ad458bf2844b628f5e593e7edd1e96")
		]
		
		guard let url = components.url else {return}
		print(url)
		let request = URLRequest(url: url)
		let newTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
			do {
				if let data = data{
					let articles = try JSONDecoder().decode(newsApiData.self, from: data).articles
					self.articles = articles
					print(articles)
					
					for (number, article) in articles.enumerated(){
						if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
							let downloadTask = URLSession.shared.dataTask(with: url) { (imageData, resp, error) in
								if let data = imageData, let image = UIImage(data: data){
									self.images[article.url] = image
									DispatchQueue.main.async { [weak self] in
										self?.tableView.reloadRows(at: [IndexPath(row: number, section: 0)], with: .none)
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
			
			DispatchQueue.main.async { [weak self] in
				self?.tableView.reloadData()
			}
			
			
		}
		newTask.resume()
	}
	
}



extension NewsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let article = articles[indexPath.row]
		if article.urlToImage != nil{
			let cell = tableView.dequeueReusableCell(withIdentifier: "mainNewsCell", for: indexPath)
			if let newsCell = cell as? NewsTableViewCell {
				newsCell.titleLabel.text = article.title
				newsCell.newsImageView.image = images[article.url] ?? UIImage(named: "roundedrect.png")
				return newsCell
			}
		}
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: "newsNoImageCell"){
			cell.textLabel?.text = article.title
			return cell
		}
	
		return UITableViewCell()
    }
    
}


extension NewsViewController: IndependentPickerController{
    
    
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
        categoryButton.setTitle(categories[row], for: .normal)
        currentSelectedCategory = (categories[row], row)
		downloadNewsForCategory(categories[row])
		
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
}

