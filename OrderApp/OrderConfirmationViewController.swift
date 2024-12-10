//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Gwen Thelin on 12/9/24.
//

import UIKit

class OrderConfirmationViewController: ViewController {
	@IBOutlet weak var confirmLabel: UILabel!
	
	var minutesToPrepare: Int

	init?(coder: NSCoder, minutesToPrepare: Int) {
		self.minutesToPrepare = minutesToPrepare
		super.init(coder: coder)
	}
	
	@MainActor required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

		confirmLabel.text = "Your order will be ready in \(minutesToPrepare) minutes."
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
