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
		case signup
		case edit
	}
	
	var presentationType = UserFormPresentationType.signup
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.navigationItem.title = "Create Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
		
		// Create a hidden bar button item to pre-populate the form
        let populateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        populateButton.addTarget(self, action: #selector(UserFormVC.populateButtonPressed(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: populateButton)
		
        form +++ Section("")
        	// Generic Row
        	<<< PickerInlineRow<String>("Roles") { (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.map { "\($0)" }
                }
                row.options = rolesArray
                row.value = row.options[0]
        	}
            <<< EmailRow("LoginRowTag"){
                $0.title = "Login"
            }
            <<< PasswordRow("PasswordRowTag"){
                $0.title = "Password"
            }
            <<< TextRow("HandleRowTag"){
                $0.title = "Handle"
            }
		+++ Section("Recruiter") {
				$0.hidden = Condition.function(["Roles"], { form in
					return (form.rowBy(tag: "Roles") as? PickerInlineRow)?.value == "Job Seeker"
				})
			}
			<<< TextRow("RFirstNameRowTag"){
                $0.title = "First Name"
            }
            <<< TextRow("RLastNameRowTag"){
                $0.title = "Last Name"
			}
			<<< EmailRow("REmailRowTag"){
                $0.title = "Email"
			}
            <<< PhoneRow("RPhoneRowTag"){
                $0.title = "Phone"
            }
            <<< TextAreaRow("RBioRowTag"){
                $0.title = "Bio"
                $0.placeholder = "Describe yourself..."
			}
		+++ Section("Job Seeker") {
				$0.hidden = Condition.function(["Roles"], { form in
					return (form.rowBy(tag: "Roles") as? PickerInlineRow)?.value == "Recruiter"
				})
			}
            <<< TextRow("JFirstNameRowTag"){
                $0.title = "First Name"
            }
            <<< TextRow("JLastNameRowTag"){
                $0.title = "Last Name"
			}
			<<< EmailRow("JEmailRowTag"){
                $0.title = "Email"
			}
            <<< PhoneRow("JPhoneRowTag"){
                $0.title = "Phone"
            }
            <<< TextAreaRow("JBioRowTag"){
                $0.title = "Bio"
                $0.placeholder = "Describe yourself..."
			}
			<<< TextRow("AvatarUrlRowTag"){
                $0.title = "Avatar Url"
			}
			<<< TextRow("HeadlineRowTag"){
                $0.title = "Headline"
			}
			<<< TextRow("CurrentPositionRowTag"){
                $0.title = "Current Position"
			}
			<<< PickerInlineRow<String>("Industry") { (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.map { "\($0)" }
                }
                row.options = industriesArray
                row.value = row.options[0]
        	}
		+++ Section("Location") {
				$0.hidden = Condition.function(["Roles"], { form in
					return (form.rowBy(tag: "Roles") as? PickerInlineRow)?.value == "Recruiter"
				})
			}
        	<<< TextRow("StreetAddressRowTag"){
                $0.title = "Street Address"
			}
			<<< TextRow("CityRowTag"){
                $0.title = "City"
			}
			<<< TextRow("StateRowTag"){
                $0.title = "State"
			}
			<<< ZipCodeRow("ZipcodeRowTag"){
                $0.title = "Zipcode"
			}
		
		// If our presentation type is edit, load the user data
		if (self.presentationType == .edit) {
			loadUser()
		}
    }
	
    @objc func populateButtonPressed(_ sender: UIBarButtonItem) {
    	 if ((form.rowBy(tag: "Roles") as? PickerInlineRow)?.value)! == "Job Seeker" {
			form.setValues([
				"LoginRowTag": "angela@mail.com",
				"PasswordRowTag": "test",
				"HandleRowTag": "AngelaMoss",
				"JFirstNameRowTag": "Angela",
				"JLastNameRowTag": "Moss",
				"JEmailRowTag": "angela@mail.com",
				"JPhoneRowTag": "123-456-7890",
				"JBioRowTag": "I'm not evil.",
				"AvatarUrlRowTag": "http://picture.com",
				"HeadlineRowTag": "Aspiring software developer that just graduated and is looking to become involved in the tech industry.",
				"CurrentPositionRowTag": "Software Engineer",
				"StreetAddressRowTag": "44 Shirley Ave",
				"CityRowTag": "West Chicago",
				"StateRowTag": "IL",
				"ZipcodeRowTag": "60185"])
		} else {
			form.setValues([
				"LoginRowTag": "john@mail.com",
				"PasswordRowTag": "test",
				"HandleRowTag": "JohnDoe",
				"RFirstNameRowTag": "John",
				"RLastNameRowTag": "Doe",
				"REmailRowTag": "john@mail.com",
				"RPhoneRowTag": "123-456-0987",
				"RBioRowTag": "Recruiter bio"])
		}
		tableView.reloadData()
    }
	
    // Action called when the "Next" button is pressed
	@IBAction func nextButtonPressed(_ sender: Any) {
		// Create the user request object
		var request = Employed_Io_CreateUserRequest()
		
		// Create the user object
		var user = Employed_Io_User()
		let roleIndex = rolesArray.index(of: ((form.rowBy(tag: "Roles") as? PickerInlineRow)?.value)!)
		user.role = Employed_Io_User.Role(rawValue: roleIndex!)!
		user.login = form.rowBy(tag: "LoginRowTag")?.baseValue as! String
		user.password = form.rowBy(tag: "PasswordRowTag")?.baseValue as! String
		user.handle = form.rowBy(tag: "HandleRowTag")?.baseValue as! String
		
		switch (user.role) {
			case .jobSeeker:
				// Create the job seeker object
				var jobSeeker = Employed_Io_JobSeeker()
				jobSeeker.firstName = form.rowBy(tag: "JFirstNameRowTag")?.baseValue as! String
				jobSeeker.lastName = form.rowBy(tag: "JLastNameRowTag")?.baseValue as! String
				jobSeeker.email = form.rowBy(tag: "JEmailRowTag")?.baseValue as! String
				jobSeeker.phoneNumber = form.rowBy(tag: "JPhoneRowTag")?.baseValue as! String
				jobSeeker.bio = form.rowBy(tag: "JBioRowTag")?.baseValue as! String
				jobSeeker.avatarURL = form.rowBy(tag: "AvatarUrlRowTag")?.baseValue as! String
				jobSeeker.headline = form.rowBy(tag: "HeadlineRowTag")?.baseValue as! String
				jobSeeker.currentPosition = form.rowBy(tag: "CurrentPositionRowTag")?.baseValue as! String
				let industryIndex = industriesArray.index(of: ((form.rowBy(tag: "Industry") as? PickerInlineRow)?.value)!)
				jobSeeker.industry = Employed_Io_Industry(rawValue: industryIndex!)!
			
				// Create the location object
				var location = Employed_Io_Location()
				location.latitude = 39.127655
				location.longitude = -84.518900
				location.address.streetAddress = form.rowBy(tag: "StreetAddressRowTag")?.baseValue as! String
				location.address.city = form.rowBy(tag: "CityRowTag")?.baseValue as! String
				location.address.state = form.rowBy(tag: "StateRowTag")?.baseValue as! String
				location.address.zip = form.rowBy(tag: "ZipcodeRowTag")?.baseValue as! String
				jobSeeker.location = location

				// Add the job seeker to the user request
				request.jobSeeker = jobSeeker
			case .recruiter:
				// Create the recruiter object
				var recruiter = Employed_Io_Recruiter()
				recruiter.firstName = form.rowBy(tag: "RFirstNameRowTag")?.baseValue as! String
				recruiter.lastName = form.rowBy(tag: "RLastNameRowTag")?.baseValue as! String
				recruiter.email = form.rowBy(tag: "REmailRowTag")?.baseValue as! String
				recruiter.phoneNumber = form.rowBy(tag: "RPhoneRowTag")?.baseValue as! String
				recruiter.bio = form.rowBy(tag: "RBioRowTag")?.baseValue as! String

				// Add the recruiter to the user request
				request.recruiter = recruiter
			case .UNRECOGNIZED(_): return
		}
		
		// Add the user to the user request
		request.user = user

		if (self.presentationType == .signup) {
			switch (user.role) {
				case .jobSeeker:
					let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SkillSelectionVC") as! SkillSelectionVC
					controller.setRequest(request: request)
					self.navigationController?.pushViewController(controller, animated: true)
				case .recruiter:
					AccountManager.shared.createUser(request: request) {
						let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"RootTabBar")
						self.present(controller, animated: true, completion: nil)
					}
				case .UNRECOGNIZED(_): return
			}
		} else {
		}
	}
	
    // Sets the presentation type
	func setPresentationType(type: UserFormPresentationType) {
		self.presentationType = type
	}
	
	// Sets the form values to the user
	func loadUser() {
		let user = AccountManager.shared.getUser()
		var data = ["LoginRowTag": user.login,
					"PasswordRowTag": user.password,
					"HandleRowTag": user.handle]

		switch user.role {
		case .jobSeeker:
			if let jobSeeker = AccountManager.shared.getJobSeeker() {
				data += ["JFirstNameRowTag": jobSeeker.firstName,
					"JLastNameRowTag": jobSeeker.lastName,
					"JEmailRowTag": jobSeeker.email,
					"JPhoneRowTag": jobSeeker.phoneNumber,
					"JBioRowTag": jobSeeker.bio,
					"AvatarUrlRowTag": jobSeeker.avatarURL,
					"HeadlineRowTag": jobSeeker.headline,
					"CurrentPositionRowTag": jobSeeker.currentPosition,
					"StreetAddressRowTag": jobSeeker.location.address.streetAddress,
					"CityRowTag": jobSeeker.location.address.city,
					"StateRowTag": jobSeeker.location.address.state,
					"ZipcodeRowTag": jobSeeker.location.address.zip]
			}
		case .recruiter:
			if let recruiter = AccountManager.shared.getRecruiter() {
				data += ["RFirstNameRowTag": recruiter.firstName,
					"RLastNameRowTag": recruiter.lastName,
					"REmailRowTag": recruiter.email,
					"RPhoneRowTag": recruiter.phoneNumber,
					"RBioRowTag": recruiter.bio]
			}
		case .UNRECOGNIZED(_): return
		}

		// Set the form values and reload the table data
		form.setValues(data)
		tableView.reloadData()
	}
}
