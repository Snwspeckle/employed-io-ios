//
//  ProfileVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/27/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {

	// Enum identifying the different prototype cells
	enum PROFILE_CELL_IDENTIFIERS: String {
		case RIGHT_DETAIL = "ProfileCellRightDetailIdentifier"
		case ACCESSORY = "ProfileCellAccessoryIdentifier"
	}

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (section) {
        	// MY ACCOUNT SECTION
        	case 0:
        		return 3
			// ACCOUNT ACTIONS SECTION
			case 1:
				return 1
			default:
				return 0
		}
    }
	
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    	switch (section) {
    		// MY ACCOUNT SECTION
    		case 0:
    			return "MY ACCOUNT"
			// ACCOUNT ACTIONS SECTION
    		case 1:
    			return "ACCOUNT ACTIONS"
			default:
				return ""
		}
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_CELL_IDENTIFIERS.RIGHT_DETAIL.rawValue, for: indexPath)
		
		// Iterate on the different sections for this table
		switch (indexPath.section) {
			// MY ACCOUNT SECTION
			case 0:
				switch (indexPath.row) {
					// Set the row for users name
					case 0:
						let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_CELL_IDENTIFIERS.RIGHT_DETAIL.rawValue, for: indexPath)
						cell.textLabel?.text = "Name"
						cell.detailTextLabel?.text = "Anthony Vella"
						return cell
					// Set the row for the profile button
					case 1:
						let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_CELL_IDENTIFIERS.ACCESSORY.rawValue, for: indexPath)
						cell.textLabel?.text = "Profile"
						return cell
					case 2:
						let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_CELL_IDENTIFIERS.ACCESSORY.rawValue, for: indexPath)
						cell.textLabel?.text = "My Jobs"
						return cell
					default:
						break;
				}
			// ACCOUNT ACTIONS SECTION
			case 1:
				switch (indexPath.row) {
					// Set the row for the logout button
					case 0:
						let cell = tableView.dequeueReusableCell(withIdentifier: PROFILE_CELL_IDENTIFIERS.ACCESSORY.rawValue, for: indexPath)
						cell.textLabel?.textColor = UIColor.red
        				cell.textLabel?.text = "Logout"
        				return cell
        			default:
        				break;
			}
			default:
				break;
		}
        return cell
    }
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
    	// User selected the "my profile" row so we should push to the UserFormVC
    	if (indexPath.section == 0 && indexPath.row == 1) {
			let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"UserFormVC") as! UserFormVC
			controller.setPresentationType(type: .edit)
			self.navigationController?.pushViewController(controller, animated: true)
		}
		
    	// User selected the "my jobs" row so we should push to the JobsVC
    	if (indexPath.section == 0 && indexPath.row == 2) {
			let controller = self.storyboard?.instantiateViewController(withIdentifier: "JobsVC") as! JobsVC
			self.navigationController?.pushViewController(controller, animated: true)
		}
		
		// User selected the "logout" row so we should unwind to the root view controller (Accounts)
		if (indexPath.section == 1 && indexPath.row == 0) {
			let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"LoginNavVC")
			self.present(controller, animated: true, completion: nil)
		}
	}
}
