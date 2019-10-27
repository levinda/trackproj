//
//  CategoryTableViewCell.swift
//  trackproj
//
//  Created by Danil on 21/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

	
	
	@IBOutlet weak var tickImageView: UIImageView!
	@IBOutlet weak var categoryLabel: UILabel!
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		// tickImageView.isHidden = !selected
		
		self.setNeedsDisplay()
        // Configure the view for the selected state
    }
    
}
