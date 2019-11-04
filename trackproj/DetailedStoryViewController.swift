//
//  DetailedStoryViewController.swift
//  trackproj
//
//  Created by Danil on 09/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import UIKit

class DetailedStoryViewController: UIViewController {

    
    @IBOutlet weak var mainImageView: UIImageView!
    
    
    
    @IBAction func dismissStory(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    var mainImage: UIImage?
	var mainText: String?
    
    
    @IBOutlet weak var mainTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
		
		mainImageView.image = mainImage
		mainImageView.layer.cornerRadius = 20
		
		mainTextView.text = mainText
        let fixedWidth = mainTextView.frame.size.width
        let newSize = mainTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        mainTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
		
		
        
        // Do any additional setup after loading the view.
    }
    
    

}
