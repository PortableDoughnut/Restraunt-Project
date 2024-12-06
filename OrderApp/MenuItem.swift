//
//  MenuItem.swift
//  OrderApp
//
//  Created by Gwen Thelin on 11/26/24.
//

import Foundation
import UIKit

struct MenuItem: Codable {
	var id: Int
	var name: String
	var detailText: String
	var price: Double
	var category: String
	var imageURL: URL
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case detailText = "description"
		case price
		case category
		case imageURL = "image_url"
	}
}
