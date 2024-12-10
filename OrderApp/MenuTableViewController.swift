//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Gwen Thelin on 11/26/24.
//

import UIKit

class MenuTableViewController: UITableViewController {
	let category: String
	let menuController: MenuController = .init()
	var menuItems: [MenuItem] = .init()
	var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]
	
	init?(coder: NSCoder, category: String) {
		self.category = category
		super.init(coder: coder)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
    super.viewDidLoad()
		
		title = category.capitalized
		
		Task.init {
			do {
				let menuItems = try await MenuController.shared.fetchMenuItems(forCategory: category)
				updateUI(with: menuItems)
			} catch {
				displayError(error, title: "Filed to Fetch Menu Items for \(self.category)")
			}
		}
  }

	func updateUI(with menuItems: [MenuItem]) {
		self.menuItems = menuItems
		self.tableView.reloadData()
	}
	
	func displayError(_ error: Error, title: String) {
		guard let _ = viewIfLoaded?.window else { return }
		
		let alert: UIAlertController = .init(title: title, message: error.localizedDescription, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
	}
	
	func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
		guard let cell = cell as? MenuItemCell else { return }
		
		let menuItem = menuItems[indexPath.row]
		
		var content = cell.defaultContentConfiguration()
		content.text = menuItem.name
		content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
		content.image = nil
		
		imageLoadTasks[indexPath] = Task.init {
			if let image = try? await MenuController.shared.fetchImage(from: menuItem.imageURL) {
				if let currentIndexPath = tableView.indexPath(for: cell),
				   currentIndexPath == indexPath {
					cell.itemName = menuItem.name
					cell.price = menuItem.price
					cell.image = image
				}
			}
			imageLoadTasks[indexPath] = nil
		}
	}
	
  // MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int { 1 }
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
	menuItems.count
}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)

		configure(cell, forItemAt: indexPath)

		return cell
	}
	
	override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		imageLoadTasks[indexPath]?.cancel()
		imageLoadTasks.forEach { key, value in value.cancel() }
	}

	@IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
		guard let cell = sender as? UITableViewCell,
			  let indexPath = tableView.indexPath(for: cell)
		else { return nil }
		
		let menuItem = menuItems[indexPath.row]
		return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
	}
}
