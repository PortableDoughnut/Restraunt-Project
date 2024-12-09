//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Gwen Thelin on 11/26/24.
//

import UIKit

@MainActor
class MenuItemDetailViewController: UIViewController {
	
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

		title = menuItem.name
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
