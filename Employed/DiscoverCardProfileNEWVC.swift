//
//  DiscoverCardProfileNEWVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/10/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit
import TagListView

class DiscoverCardProfileNEWVC: UIViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var jobNameLabel: UILabel!
	@IBOutlet weak var companyNameLabel: UILabel!
	
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var salaryLabel: UILabel!
	@IBOutlet weak var experienceLabel: UILabel!
	
	@IBOutlet weak var midStackView: UIStackView!
	@IBOutlet weak var jobDescriptionLabel: UILabel!
	@IBOutlet weak var responsibilitiesLabel: UILabel!
	@IBOutlet weak var requirementsLabel: UILabel!
	
	@IBOutlet weak var tagListView: TagListView!
	
	@IBOutlet weak var recruiterImageView: UIImageView!
	@IBOutlet weak var recruiterNameLabel: UILabel!
	
	var shouldShowTagList = false
	var recruiterImage: String!
	
	var job: Employed_Io_Job?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Remove the tag list view by default
//        self.midStackView.removeArrangedSubview(self.tagListView)

        // Set the company picture
        // NOTE: This is temporarily fixed as we aren't loading images from the network yet
        self.pictureImageView.image = UIImage(named: "ecorp")
        self.pictureImageView.clipsToBounds = true
        self.pictureImageView.layer.cornerRadius = self.pictureImageView.frame.width / 2
		
		// Set the job label
		self.jobNameLabel.text = self.job?.title
		
		// Set the company label
		self.companyNameLabel.text = self.job?.company.name
		
		// Set the location label
		if let address = self.job?.jobAddress {
			// Gets the first to characters in the state and uppercases them
			let indexStartOf = address.state.index(address.state.startIndex, offsetBy: 2)
			let state = address.state[..<indexStartOf].uppercased()
			
			self.locationLabel.text = address.city + ", " + state
		}
		
		// Set the salary label
		if let salary = self.job?.salary {
			self.salaryLabel.text = String(format: "$%.0fk", salary)
		}
		
		// Set the experience label
		if let experience = self.job?.experience {
			self.experienceLabel.text = experience
		}
		
		// Set the short job description
		if let description = self.job?.shortDescription {
			self.jobDescriptionLabel?.text = description
		}
		
		// Set the responsibilities
		if let responsibilities = self.job?.responsibilities {
			self.responsibilitiesLabel?.text = responsibilities
		}
		
		// Set the requirements
		if let requirements = self.job?.requirements {
			self.requirementsLabel?.text = requirements
		}
		
		// Set the tags
		if let tagList = self.tagListView {
			tagList.textFont = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
			if let tags = self.job?.tag.tagName {
				let tagSlice = tags[0].split(separator: ";")
				let tagArray = Array(tagSlice)
				for tag in tagArray {
					tagList.addTag(String(tag))
				}
			}
		}
		
		// Set the recruiter label
		if let firstName = self.job?.recruiter.name.firstName, let lastName = self.job?.recruiter.name.lastName {
			self.recruiterNameLabel.text = firstName + " " + lastName
			
			switch firstName {
			case "Angela": self.recruiterImage = "angela_moss"
			case "Tyrell": self.recruiterImage = "tyrell_wellick"
			case "Phillip": self.recruiterImage = "phillip_price"
			default: self.recruiterImage = "angela_moss"
			}
		}
		
		// Set the recruiter picture
		// NOTE: This is temporarily fixed as we aren't loading images from the network yet
		self.recruiterImageView.image = UIImage(named: self.recruiterImage)
		self.recruiterImageView.clipsToBounds = true
		self.recruiterImageView.layer.cornerRadius = self.recruiterImageView.frame.width / 2
    }
	
    override func viewWillAppear(_ animated: Bool) {
    	super.viewWillAppear(animated)
//		if shouldShowTagList {
//			self.midStackView.addArrangedSubview(self.tagListView)
//		}
	}
	
	// Sets the job object
    func setJob(job: Employed_Io_Job) -> Void {
    	self.job = job
	}
	
	// Add the tag view to the vertical mid stack view
	func showTagView() -> Void {
		self.shouldShowTagList = true
	}

}

