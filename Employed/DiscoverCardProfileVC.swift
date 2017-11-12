//
//  DiscoverCardProfileVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/10/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit

class DiscoverCardProfileVC: UIViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var jobNameLabel: UILabel!
	@IBOutlet weak var companyNameLabel: UILabel!
	
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var salaryLabel: UILabel!
	@IBOutlet weak var experienceLabel: UILabel!
	
	@IBOutlet weak var recruiterImageView: UIImageView!
	@IBOutlet weak var recruiterNameLabel: UILabel!
	
	var job: Employed_Io_Job?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Set the company picture
        // NOTE: This is temporarily fixed as we aren't loading images from the network yet
        self.pictureImageView.image =  UIImage(named: "ecorp")
		
		// Set the job label
		self.jobNameLabel.text = self.job?.title
		
		// Set the company label
		self.companyNameLabel.text = self.job?.company.name
		
		// Set the location label
		if let address = self.job?.address {
			// Gets the first to characters in the state and uppercases them
			let indexStartOf = address.state.index(address.state.startIndex, offsetBy: 2)
			let state = address.state[..<indexStartOf].uppercased()
			
			self.locationLabel.text = address.city + ", " + state
		}
		
		// Set the salary label
		if let salary = self.job?.salary {
			self.salaryLabel.text = String(format: "$%.0fk", salary)
		}
		
		// Set the recruiter label
		if let firstName = self.job?.recruiter.name.firstName, let lastName = self.job?.recruiter.name.lastName {
			self.recruiterNameLabel.text = firstName + " " + lastName
		}
		
		// Set the recruiter picture
		// NOTE: This is temporarily fixed as we aren't loading images from the network yet
		self.recruiterImageView.image = UIImage(named: "angela_moss")
		self.recruiterImageView.clipsToBounds = true
		self.recruiterImageView.layer.cornerRadius = self.recruiterImageView.frame.width / 2
    }
	
	// Sets the job object
    func setJob(job: Employed_Io_Job) -> Void {
    	self.job = job
	}

}
