//
//  DiscoverProfileVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/10/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit
import TagListView

// Declaration of the two different presentation styles for this view
enum DiscoverProfilePresentationType {
	case Card
	case Full
}

class DiscoverProfileVC: UIViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var jobNameLabel: UILabel!
	@IBOutlet weak var companyNameLabel: UILabel!
	
	@IBOutlet weak var locationLabel: UILabel!
	@IBOutlet weak var salaryLabel: UILabel!
	@IBOutlet weak var experienceLabel: UILabel!
	
	@IBOutlet weak var fieldsStackView: UIStackView!
	
	@IBOutlet weak var tagListView: TagListView!
	
	@IBOutlet weak var recruiterImageView: UIImageView!
	@IBOutlet weak var recruiterNameLabel: UILabel!
	
	var recruiterImage: String!
	
	var job: Employed_Io_Job?
	
	// The presentation type of this view controller. Presentation type represents whether
	// this view controller is being displayed in a card or full form.
	var presentationType: DiscoverProfilePresentationType = .Card
	
    override func viewDidLoad() {
        super.viewDidLoad()

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
		
		// Set the job description for both card and full view
		if let description = self.job?.description_p {
			if let field = FieldView.create(title: "Job Description", body: description) {
				self.fieldsStackView.addArrangedSubview(field)
			}
		}
		
		// Create the field view for job description
		if presentationType == .Full {
			// Set the responsibilities
			if let responsibilities = self.job?.responsibilities {
				if let field = FieldView.create(title: "Responsibilities", body: responsibilities) {
					self.fieldsStackView.addArrangedSubview(field)
				}
			}
			
			// Set the requirements
			if let requirements = self.job?.requirements {
				if let field = FieldView.create(title: "Requirements", body: requirements) {
					self.fieldsStackView.addArrangedSubview(field)
				}
			}
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
	
	// Sets the job object
    func setJob(job: Employed_Io_Job) -> Void {
    	self.job = job
	}
	
	// Sets the presentation type
	func setPresentationType(type: DiscoverProfilePresentationType) -> Void {
		self.presentationType = type
	}

}

