//
//  ResponseModels.swift
//  OrderApp
//
//  Created by Gwen Thelin on 12/6/24.
//

import UIKit

struct MenuResponse: Codable {
	let items: [MenuItem]
}

struct CategoriesResponse: Codable {
	let categories: [String]
}

struct OrderResponse: Codable {
	let prepTime: Int
	
	enum CodingKeys: String, CodingKey {
		case prepTime = "preparation_time"
	}
}
