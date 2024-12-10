//
//  MenuController.swift
//  OrderApp
//
//  Created by Gwen Thelin on 12/6/24.
//

import Foundation
import UIKit

enum MenuControllerError: Error, LocalizedError, CustomStringConvertible {
	var description: String {
		switch self {
			case .categoriesNotFound:
				"Could not find categories."
			case .menuItemsNotFound:
				"Could not find menu items"
			case .orderRequestFailed:
				"Order Request Failed"
			case .imageDataMissing:
				"Image data missing"
		}
	}
	
	case categoriesNotFound
	case menuItemsNotFound
	case orderRequestFailed
	case imageDataMissing
}

class MenuController {
	static let shared: MenuController = .init()
	static let orderUpdatedNotification = Notification.Name("MenuController.orderUpdated")
	
	var order: Order = .init() {
		didSet {
			NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
		}
	}
	let baseURL: URL = .init(string: "http://localhost:8080/")!
	typealias MinutesToPrepare = Int
	typealias ID = Int
	
	func fetchCategories() async throws -> [String] {
		let categoriesURL = baseURL.appendingPathComponent("categories")
		let (data, response) = try await URLSession.shared.data(from: categoriesURL)
		
		guard let httpResponse = response as? HTTPURLResponse,
			  httpResponse.statusCode == 200
		else {
			throw MenuControllerError.orderRequestFailed
		}
		
		let decoder: JSONDecoder = .init()
		let categoriesResponse = try decoder.decode(CategoriesResponse.self, from: data)
		
		return categoriesResponse.categories
	}
	
	func fetchMenuItems(forCategory categoryName: String) async throws -> [MenuItem] {
		let baseMenuURL: URL = baseURL.appendingPathComponent("menu")
		var components: URLComponents = .init(url: baseMenuURL, resolvingAgainstBaseURL: true)!
		
		components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
		
		let menuURL: URL = components.url!
		let (data, response) = try await URLSession.shared.data(from: menuURL)
		
		guard let httpResponse = response as? HTTPURLResponse,
			  httpResponse.statusCode == 200
		else {
			throw MenuControllerError.menuItemsNotFound
		}
		
		let decoder: JSONDecoder = .init()
		let menuResponse = try decoder.decode(MenuResponse.self, from: data)
		
		return menuResponse.items
	}
	
	func fetchImage(from url: URL) async throws -> UIImage {
		let (data, response) = try await URLSession.shared.data(from: url)
		
		guard let httpResponse = response as? HTTPURLResponse,
			  httpResponse.statusCode == 200
		else {
			throw MenuControllerError.imageDataMissing
		}
		
		guard let image: UIImage = .init(data: data)
		else { throw MenuControllerError.imageDataMissing }
		
		return image
	}
	
	func submitOrder(forMenuIDs menuIDs: [ID]) async throws -> MinutesToPrepare {
			let orderURL: URL = baseURL.appendingPathComponent("order")
			var request: URLRequest = .init(url: orderURL)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			
			let menuIdsDictionary = ["menuIds": menuIDs]
			let jsonEncoder: JSONEncoder = .init()
			let jsonData = try? jsonEncoder.encode(menuIdsDictionary)
			
			request.httpBody = jsonData
			let (data, response) = try await URLSession.shared.data(for: request)
		if let jsonString = String(data: data, encoding: .utf8) {
			print(jsonString)
		}
			
			guard let httpResponse = response as? HTTPURLResponse,
				  httpResponse.statusCode == 200
			else {
				throw MenuControllerError.orderRequestFailed
			}
			
			let decoder: JSONDecoder = .init()
		
			let orderResponse = try decoder.decode(OrderResponse.self, from: data)
		
			
		return orderResponse.prepTime
	}
}
