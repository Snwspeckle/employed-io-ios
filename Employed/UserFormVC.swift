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
		case Embedded
		case Individual
	}
	
	var presentationType = UserFormPresentationType.Individual
	
	let roles = ["Job Seeker", "Recruiter"]
	let industries = ["Engineering", "Business", "Design", "Arts Entertainment", "Communications", "Education", "Environment", "Government", "Health", "International", "Law", "Non-Profit", "Sciences"]
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        self.navigationItem.title = "Create Profile"
        self.navigationController?.navigationBar.tintColor = UIColor.white
		
		// Create a hidden bar button item to pre-populate the form
        let populateButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        populateButton.addTarget(self, action: #selector(UserFormVC.populateButtonPressed(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: populateButton)
		
        form +++ Section("")
        	<<< PickerInlineRow<String>("Roles") { (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.map { "\($0)" }
                }
                row.options = roles
                row.value = row.options[0]
        	}
            <<< EmailRow(){
            	$0.tag = "LoginRowTag"
                $0.title = "Login"
                $0.placeholder = "Enter text here"
            }
            <<< PasswordRow(){
            	$0.tag = "PasswordRowTag"
                $0.title = "Password"
                $0.placeholder = "Enter text here"
            }
            <<< TextRow(){
            	$0.tag = "HandleRowTag"
                $0.title = "Handle"
                $0.placeholder = "Enter text here"
            }
            <<< TextRow(){
            	$0.tag = "FirstNameRowTag"
                $0.title = "First Name"
                $0.placeholder = "Enter text here"
            }
            <<< TextRow(){
            	$0.tag = "LastNameRowTag"
                $0.title = "Last Name"
                $0.placeholder = "Enter text here"
			}
			<<< EmailRow(){
				$0.tag = "EmailRowTag"
                $0.title = "Email"
                $0.placeholder = "Enter email here"
			}
            <<< PhoneRow(){
            	$0.tag = "PhoneRowTag"
                $0.title = "Phone"
                $0.placeholder = "Enter phone here"
            }
            <<< TextAreaRow(){
            	$0.tag = "BioRowTag"
                $0.title = "Bio"
                $0.placeholder = "Enter bio here"
			}
			<<< TextRow(){
            	$0.tag = "AvatarUrlRowTag"
                $0.title = "Avatar Url"
                $0.placeholder = "Enter text here"
			}
			<<< TextRow(){
            	$0.tag = "HeadlineRowTag"
                $0.title = "Headline"
                $0.placeholder = "Enter text here"
			}
			<<< TextRow(){
            	$0.tag = "CurrentPositionRowTag"
                $0.title = "Current Position"
                $0.placeholder = "Enter text here"
			}
			<<< PickerInlineRow<String>("Industry") { (row : PickerInlineRow<String>) -> Void in
                row.title = row.tag
                row.displayValueFor = { (rowValue: String?) in
                    return rowValue.map { "\($0)" }
                }
                row.options = industries
                row.value = row.options[0]
        	}
		+++ Section("Location")
        	<<< TextRow(){
            	$0.tag = "StreetAddressRowTag"
                $0.title = "StreetAddress"
                $0.placeholder = "Enter text here"
			}
			<<< TextRow(){
            	$0.tag = "CityRowTag"
                $0.title = "City"
                $0.placeholder = "Enter text here"
			}
			<<< TextRow(){
            	$0.tag = "StateRowTag"
                $0.title = "State"
                $0.placeholder = "Enter text here"
			}
			<<< ZipCodeRow(){
            	$0.tag = "ZipcodeRowTag"
                $0.title = "Zipcode"
                $0.placeholder = "Enter text here"
			}
    }
	
    @objc func populateButtonPressed(_ sender: UIBarButtonItem) {
		form.setValues([
				"LoginRowTag": "anthony@mail.com",
				"PasswordRowTag": "test",
				"HandleRowTag": "AnthonyVella",
				"FirstNameRowTag": "Anthony",
				"LastNameRowTag": "Vella",
				"EmailRowTag": "anthony@mail.com",
				"PhoneRowTag": "123-456-7890",
				"BioRowTag": "Test",
				"AvatarUrlRowTag": "http://picture.com",
				"HeadlineRowTag": "This is a headline",
				"CurrentPositionRowTag": "Software Engineer",
				"StreetAddressRowTag": "196 Forestview Place",
				"CityRowTag": "Aurora",
				"StateRowTag": "OH",
				"ZipcodeRowTag": "44202"])
		tableView.reloadData()
    }
	
    // Action called when the "Next" button is pressed
	@IBAction func nextButtonPressed(_ sender: Any) {
		// Create the user request object
		var request = Employed_Io_CreateUserRequest()
		
		// Create the user object
		var user = Employed_Io_User()
		user.role = .jobSeeker
		user.login = form.rowBy(tag: "LoginRowTag")?.baseValue as! String
		user.password = form.rowBy(tag: "PasswordRowTag")?.baseValue as! String
		user.handle = form.rowBy(tag: "HandleRowTag")?.baseValue as! String
		user.matches = [""]
		user.pendingMatches = [""]
		user.rejectedMatches = [""]
		
		// Create the job seeker object
		var jobSeeker = Employed_Io_JobSeeker()
		jobSeeker.firstName = form.rowBy(tag: "FirstNameRowTag")?.baseValue as! String
		jobSeeker.lastName = form.rowBy(tag: "LastNameRowTag")?.baseValue as! String
		jobSeeker.email = form.rowBy(tag: "EmailRowTag")?.baseValue as! String
		jobSeeker.phoneNumber = form.rowBy(tag: "PhoneRowTag")?.baseValue as! String
		jobSeeker.bio = form.rowBy(tag: "BioRowTag")?.baseValue as! String
		jobSeeker.avatarURL = form.rowBy(tag: "AvatarUrlRowTag")?.baseValue as! String
		jobSeeker.headline = form.rowBy(tag: "HeadlineRowTag")?.baseValue as! String
		jobSeeker.currentPosition = form.rowBy(tag: "CurrentPositionRowTag")?.baseValue as! String
		jobSeeker.industry = .engineering
		
		// Create the location object
		var location = Employed_Io_Location()
		location.latitude = 39.127655
		location.longitude = -84.518900
		location.address.streetAddress = form.rowBy(tag: "StreetAddressRowTag")?.baseValue as! String
		location.address.city = form.rowBy(tag: "CityRowTag")?.baseValue as! String
		location.address.state = form.rowBy(tag: "StateRowTag")?.baseValue as! String
		location.address.zip = form.rowBy(tag: "ZipcodeRowTag")?.baseValue as! String
		jobSeeker.location = location
		
		// Add the user to the user request
		request.user = user
		
		// Add the job seeker to the user request
		request.jobSeeker = jobSeeker

		if (self.presentationType == .Embedded) {
			let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"SkillSelectionVC") as! SkillSelectionVC
			controller.setRequest(request: request)
			self.navigationController?.pushViewController(controller, animated: true)
		} else {
			
		}
	}
	
    // Sets the presentation type
	func setPresentationType(type: UserFormPresentationType) {
		self.presentationType = type
	}
}
