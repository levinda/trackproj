//
//  ViewController.swift
//  trackproj
//
//  Created by Danil on 27/09/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    // MARK: Temporal Data
    
    let images: [String] = ["amster.JPG","table.jpg","shipsun.jpg"]
    let titles: [String] = ["New canal opening", "Mind teez invention. Literally.", "Offensive Russian navy campaign in the Atlantic "]
    
    let categories: [String] = ["Main News", "Music", "Politics", "Crime", "Hot"]
    var currentSelectedCategory: (name: String, number: Int) = ("Main News", 0)
    
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
            let picker = IndependentPickerView(frame: CGRect(x: 0, y: self.view.bounds.height * 2/3, width: view.bounds.width, height: view.bounds.height / 3  ))
            picker.controller = self
            picker.pickerView.selectRow(currentSelectedCategory.number, inComponent: 0, animated: false)
            self.view.addSubview(picker)
            pickerView = picker
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        tableView.setNeedsLayout()
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showStory" {
            if let newsCell = sender as? NewsTableViewCell{
                if let destinationVC = segue.destination as? DetailedStoryViewController{
                    destinationVC.mainImage = newsCell.newsImageView.image
                }
            }
        }
    }
    
    
    
    
}


extension NewsViewController: UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainNewsCell", for: indexPath)
        if let newsCell = cell as? NewsTableViewCell {
            newsCell.newsImageView.image = UIImage(named: images[indexPath.row])
            newsCell.titleLabel.text = titles[indexPath.row]
            return newsCell
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
        
        categoryButton.setTitle(categories[row], for: .normal)
        currentSelectedCategory = (categories[row], row)
    }
    
}

