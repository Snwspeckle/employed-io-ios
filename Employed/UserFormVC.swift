//
//  UserFormVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/28/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import Eureka

class UserFormVC: FormViewController {

	enum UserFormPresentationType {
		case Onboarding
		case Individual
	}
	
	var presentationType = UserFormPresentationType.Individual
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.navigationItem.title = "Create Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
		
        form +++ Section("")
            <<< TextRow(){ row in
                row.title = "First Name"
                row.placeholder = "Enter text here"
            }
            <<< TextRow(){
                $0.title = "Last Name"
                $0.placeholder = "Enter text here"
			}
			<<< EmailRow(){
                $0.title = "Email"
                $0.placeholder = "Enter email here"
			}
            <<< PhoneRow(){
                $0.title = "Phone"
                $0.placeholder = "Enter phone here"
            }
            <<< TextAreaRow(){
                $0.title = "Bio"
                $0.placeholder = "Enter bio here"
			}
    }
	
    // Action called when the "Next" button is pressed
	@IBAction func nextButtonPressed(_ sender: Any) {
		if (self.presentationType == .Onboarding) {
			let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SkillSelectionVC")
			self.navigationController?.pushViewController(controller, animated: true)
		} else {
			
		}
	}
	
    // Sets the presentation type
	func setPresentationType(type: UserFormPresentationType) -> Void {
		self.presentationType = type
	}
}
