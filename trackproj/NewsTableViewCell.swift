//
//  newsTableViewCell.swift
//  trackproj
//
//  Created by Danil on 08/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var newsImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func draw(_ rect: CGRect) {
        
        // Потом нужно запихать в функцию
        
        newsImageView.layer.sublayers = []
        let gradient = CAGradientLayer()
        gradient.frame = newsImageView.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradient.locations = [0.6,1]
        newsImageView.layer.addSublayer(gradient)
        
        
        newsImageView.layer.cornerRadius = 20.0
        newsImageView.clipsToBounds = true
        
                
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
