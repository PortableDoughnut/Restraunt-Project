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
		let menuItem = menuItems[indexPath.row]
		
		var content = cell.defaultContentConfiguration()
		content.text = menuItem.name
		content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
		cell.contentConfiguration = content
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


  /*
	 // MARK: - Navigation

	 // In a storyboard-based application, you will often want to do a little preparation before navigation
	 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		 // Get the new view controller using segue.destination.
		 // Pass the selected object to the new view controller.
	 }
	 */
	
	@IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
		guard let cell = sender as? UITableViewCell,
			  let indexPath = tableView.indexPath(for: cell)
		else { return nil }
		
		let menuItem = menuItems[indexPath.row]
		return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
	}
}
