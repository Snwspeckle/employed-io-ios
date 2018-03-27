//
//  ProfileVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/27/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

class ProfileVC: UITableViewController {

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCellRightDetailIdentifier", for: indexPath)
		
		// Iterate on the different sections for this table
		switch (indexPath.section) {
			// MY ACCOUNT SECTION
			case 0:
				switch (indexPath.row) {
					// Set the row for users name
					case 0:
						let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCellRightDetailIdentifier", for: indexPath)
						cell.textLabel?.text = "Name"
						cell.detailTextLabel?.text = "Anthony Vella"
						return cell
					// Set the row for the profile button
					case 1:
						let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCellAccessoryIdentifier", for: indexPath)
						cell.textLabel?.text = "Profile"
						return cell
					case 2:
						let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCellAccessoryIdentifier", for: indexPath)
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
						let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCellAccessoryIdentifier", for: indexPath)
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
    	// User selected the "my jobs" row so we should push to the JobsVC
    	if (indexPath.section == 0 && indexPath.row == 2) {
			let vc = self.storyboard?.instantiateViewController(withIdentifier: "JobsVC") as! JobsVC
			self.navigationController?.pushViewController(vc, animated: true)
		}
		
		// User selected the "logout" row so we should unwind to the root view controller (Accounts)
		if (indexPath.section == 1 && indexPath.row == 0) {
			hero.unwindToRootViewController()
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
