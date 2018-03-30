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
    }

	// Listen for touches to dismiss the keyboard when tapping outside
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		self.view.endEditing(true)
	}
	
	@IBAction func signInButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"RootTabBar")
		self.present(controller, animated: true, completion: nil)
	}
	
	@IBAction func signUpButtonPressed(_ sender: Any) {
		let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"UserFormVC") as! UserFormVC
		controller.setPresentationType(type: .Onboarding)
		self.navigationController?.pushViewController(controller, animated: true)
	}
}
