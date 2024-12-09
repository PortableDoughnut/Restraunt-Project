//
//  CatageoryTableViewController.swift
//  OrderApp
//
//  Created by Gwen Thelin on 11/26/24.
//

import UIKit

@MainActor
class CatageoryTableViewController: UITableViewController {
	let menuController: MenuController = .init()
	var categories: [String] = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		Task.init {
			do {
				let categories = try await MenuController.shared.fetchCategories()
			} catch {
				displayError(error, title: "Failed to Fetch Categories")
			}
		}
    }

	func updateUI(with categories: [String]) {
		self.categories = categories
		self.tableView.reloadData()
	}
	
	func displayError(_ error: Error, title: String) {
		guard let _  = viewIfLoaded?.window else { return }
		
		let alert: UIAlertController = .init(
			title: title,
			message: error.localizedDescription, preferredStyle: .alert
		)
		
		alert.addAction(UIAlertAction(
			title: "Dismiss",
			style: .default,
			handler: nil
		))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func configureCell(_ cell: UITableViewCell, forCategoryAt indexPath: IndexPath) {
		let category: String = categories[indexPath.row]
		var content: UIListContentConfiguration = cell.defaultContentConfiguration()
		
		content.text = category.capitalized
		cell.contentConfiguration = content
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category", for: indexPath)
		configureCell(cell, forCategoryAt: indexPath)
		
        return cell
    }
	
	@IBSegueAction func showMenu(_ coder: NSCoder, sender: Any?) -> MenuTableViewController? {
		guard let cell = sender as? UITableViewCell,
			  let indexPath = tableView.indexPath(for: cell)
		else { return nil }
		
		let category = categories[indexPath.row]
		return MenuTableViewController(coder: coder, category: category)
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
