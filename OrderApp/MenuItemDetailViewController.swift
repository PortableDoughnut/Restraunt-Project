//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Gwen Thelin on 11/26/24.
//

import UIKit

@MainActor
class MenuItemDetailViewController: UIViewController {
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var addToOrderButton: UIButton!
	@IBOutlet weak var detailLabel: UILabel!
	@IBOutlet weak var imageLabel: UIImageView!
	
	let menuItem: MenuItem
	
	init?(coder: NSCoder, menuItem: MenuItem) {
		self.menuItem = menuItem
		super.init(coder: coder)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		updateUI()
    }
    
	func updateUI() {
		nameLabel.text = menuItem.name
		priceLabel.text = menuItem.price.formatted(.currency(code: "usd"))
		detailLabel.text = menuItem.detailText
		
		Task.init {
			if let image = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
				imageLabel.image = image
			}
		}
	}

	@IBAction func addtoOrderButtonTapped(_ sender: UIButton) {
		UIView.animate(
			withDuration: 0.5,
			delay: 0,
			usingSpringWithDamping: 0.7,
			initialSpringVelocity: 0.1,
			options: [],
			animations: {
				self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.47, y: 1.47)
				self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		},
			completion: nil
		)
		
		MenuController.shared.order.menuItems.append(menuItem)
	}
	
	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
