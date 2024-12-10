//
//  MenuItem.swift
//  OrderApp
//
//  Created by Gwen Thelin on 11/26/24.
//

import Foundation
import UIKit

struct MenuItem: Codable {
	let id: Int
	let name: String
	let detailText: String
	let category: String
	let imageURL: String
	let price: Double
	
	enum CodingKeys: String, CodingKey {
		case id, name, category, price
		case detailText = "description"
		case imageURL = "image_url"
	}
}
