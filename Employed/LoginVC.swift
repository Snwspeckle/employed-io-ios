//
//  LoginVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/30/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginVC: UIViewController {

	@IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
	@IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Create a hidden bar button item to pre-populate the form
        let populateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        populateButton.addTarget(self, action: #selector(LoginVC.populateButtonPressed(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: populateButton)
    }

	// Listen for touches to dismiss the keyboard when tapping outside
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	 @objc func populateButtonPressed(_ sender: UIBarButtonItem) {
		self.usernameTextField.text = "anthony@mail.com"
		self.passwordTextField.text = "test"
    }
	
	@IBAction func signInButtonPressed(_ sender: Any) {
		AccountManager.shared.login(username: usernameTextField.text!, password: passwordTextField.text!) {
			// Present the main portion of the app
			let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"RootTabBar")
			self.present(controller, animated: true, completion: nil)
		}
	}
	
	@IBAction func signUpButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"UserFormVC") as! UserFormVC
		controller.setPresentationType(type: .signup)
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
