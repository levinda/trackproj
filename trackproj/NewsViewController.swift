//
//  ViewController.swift
//  trackproj
//
//  Created by Danil on 27/09/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    let images: [String] = ["amster.JPG","table.jpg","shipsun.jpg"]
    let titles: [String] = ["New canal opening", "Mind teez invention. Literally.", "Offensive Russian navy campaign in the Atlantic "]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillLayoutSubviews() {
        tableView.setNeedsLayout()
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

