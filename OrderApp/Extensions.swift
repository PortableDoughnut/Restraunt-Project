//
//  Extensions.swift
//  OrderApp
//
//  Created by Gwen Thelin on 12/6/24.
//

import UIKit

extension URL {
	func toImage() async -> UIImage? {
		do {
			let (data, response) = try await URLSession.shared.data(from: self)
			return  UIImage(data: data)
		} catch {
			print(error)
			return nil
		}
	}
}
