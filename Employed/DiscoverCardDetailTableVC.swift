//
//  DiscoverCardDetailTableVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/12/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit

class DiscoverCardDetailTableVC: UITableViewController {
	
	var job: Employed_Io_Job?
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
    // Sets the job object
    func setJob(job: Employed_Io_Job) -> Void {
    	self.job = job
	}
	
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
	
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat(44)
	}
	
	// Setup the tableview section header titles
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		switch section {
		case 0:
			return "Description"
		case 1:
			return "Responsibilities"
		case 2:
			return "Requirements"
		default:
			return ""
		}
	}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardDetailCellIdentifier", for: indexPath)
		
		switch indexPath.section {
		case 0:
			cell.textLabel?.text = self.job?.description_p
		case 1:
			cell.textLabel?.text = self.job?.responsibilities
		case 2:
			cell.textLabel?.text = self.job?.requirements
		default:
			break
		}

        return cell
    }

}
