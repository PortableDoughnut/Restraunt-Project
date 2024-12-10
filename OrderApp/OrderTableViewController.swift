//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Gwen Thelin on 11/26/24.
//

import UIKit

class OrderTableViewController: UITableViewController {
	
	var order: Order = .init()
	
	var minutesToPrepareOrder: Int = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(
			tableView!,
			selector: #selector(UITableView.reloadData),
			name: MenuController.orderUpdatedNotification,
			object: nil)
		
		self.navigationItem.leftBarButtonItem = self.editButtonItem
	}
	
	func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
		let menuItem = MenuController.shared.order.menuItems[indexPath.row]
		
		var content = cell.defaultContentConfiguration()
		content.text = menuItem.name
		content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
		cell.contentConfiguration = content
	}
	
	func uploadOrder() {
		let menuIds = MenuController.shared.order.menuItems.map { $0.id }
		
		Task.init {
			do {
				let minutesToPrepare = try await MenuController.shared.submitOrder(forMenuIDs: menuIds)
				print("Preparation time: \(minutesToPrepare)")
				minutesToPrepareOrder = minutesToPrepare
				DispatchQueue.main.async {
					self.performSegue(withIdentifier: "confirmOrder", sender: nil)
				}
			} catch {
				print("Error: \(error)")
				displayError(error, title: "Order Submission Failed")
			}
		}
	}
	
	func displayError(_ error: Error, title: String) {
		guard let _ = viewIfLoaded?.window else { return }
		let alert: UIAlertController = .init(
			title: title,
			message: error.localizedDescription,
			preferredStyle: .alert
		)
		alert.addAction(.init(title: "Dismiss",
							  style: .default,
							  handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
		// MARK: - Table view data source
	
	override func numberOfSections(in tableView: UITableView) -> Int {
		1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		MenuController.shared.order.menuItems.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
		
		configure(cell, forItemAt: indexPath)
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		true
	}
	
	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			MenuController.shared.order.menuItems.remove(at: indexPath.row)
				//            tableView.deleteRows(at: [indexPath], with: .fade)
		}
		
		/*
		 // Override to support conditional rearranging of the table view.
		 override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
		 // Return false if you do not want the item to be re-orderable.
		 return true
		 }
		 */
		
		/*
		 // MARK: - Navigation
		 
		 // In a storyboard-based application, you will often want to do a little preparation before navigation
		 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		 // Get the new view controller using segue.destination.
		 // Pass the selected object to the new view controller.
		 }
		 */
		
	}
	
	@IBAction func unwindToOrder(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
		if unwindSegue.identifier == "unwindToOrder" {
			MenuController.shared.order.menuItems.removeAll()
		}
	}
	
	@IBAction func submitPressed(_ sender: UIBarButtonItem) {
		print("Submit button pressed!")
		
		let orderTotal: Double = MenuController.shared.order.menuItems.reduce(0) { $0 + $1.price }
		let formattedTotal = orderTotal.formatted(.currency(code: "usd"))
		
		let alertController = UIAlertController(
			title: "Confirm Order",
			message: "You are about to submit your order with a total of \(formattedTotal)",
			preferredStyle: .actionSheet
		)
		
		alertController.addAction(UIAlertAction(title: "Submit", style: .default, handler: { _ in
			print("Submit action triggered!")
			self.uploadOrder()
		}))
		
		alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
		
		present(alertController, animated: true, completion: nil)
	}
	@IBSegueAction func confirmOrder(_ coder: NSCoder) -> OrderConfirmationViewController? {
		OrderConfirmationViewController(coder: coder, minutesToPrepare: minutesToPrepareOrder)
	}
}
