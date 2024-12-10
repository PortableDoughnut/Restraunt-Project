//
//  MenuItemCell.swift
//  OrderApp
//
//  Created by Gwen Thelin on 12/10/24.
//

import UIKit

class MenuItemCell: UITableViewCell {
	var itemName: String? = nil {
		didSet {
			if oldValue != itemName {
				setNeedsUpdateConfiguration()
			}
		}
	}
	var price: Double? = nil {
		didSet {
			if oldValue != price {
				setNeedsUpdateConfiguration()
			}
		}
	}
	var image: UIImage? = nil {
		didSet {
			if oldValue != image {
				setNeedsUpdateConfiguration()
			}
		}
	}
	
	override func updateConfiguration(using state: UICellConfigurationState) {
		var content = defaultContentConfiguration().updated(for: state)
		content.text = itemName
		content.secondaryText = price?.formatted(.currency(code: "usd"))
		content.prefersSideBySideTextAndSecondaryText = true
		
		if let image = image {
			content.image = image.preparingThumbnail(of: CGSizeMake(80, 80))
		} else {
			content.image = UIImage(systemName: "photo.on.rectangle")
		}
		
		self.contentConfiguration = content
	}
}
