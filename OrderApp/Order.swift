//
//  Order.swift
//  OrderApp
//
//  Created by Gwen Thelin on 12/6/24.
//

import UIKit

struct Order: Codable {
	var menuItems: [MenuItem]
	
	init(menuItems: [MenuItem] = []) {
		self.menuItems = menuItems
	}
}
