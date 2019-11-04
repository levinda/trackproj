//
//  Article.swift
//  trackproj
//
//  Created by Danil on 27/10/2019.
//  Copyright © 2019 levinda. All rights reserved.
//

import Foundation

struct newsApiData: Codable {
	var articles: [Article]
}
struct Article: Codable{
	
	var title: String
	var url: String
	var urlToImage: String?
	var content: String?
	
}
