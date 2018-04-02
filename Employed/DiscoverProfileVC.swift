//
//  DiscoverProfileVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/10/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import CoreLocation
import MapKit
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
	@IBOutlet weak var mapView: MKMapView!
	
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
		
		// Set the first quick stack view
		let firstQuickStackView = UIStackView()
		firstQuickStackView.axis = .horizontal
		firstQuickStackView.distribution = .fillEqually
		firstQuickStackView.alignment = .fill
		firstQuickStackView.hero.id = "firstQuickStackView"
		
		// Add the first quick stack view to the field stack view
		self.fieldsStackView.addArrangedSubview(firstQuickStackView)
		
		// Set the location label
		if let address = self.job?.location.address {
			if let quickField = QuickFieldView.create(title: "Location", body: address.city + ", " + address.state) {
				firstQuickStackView.addArrangedSubview(quickField)
			}
		}
		
		// Set the salary label
		if let salary = self.job?.salary {
			let formatter = NumberFormatter()
			formatter.numberStyle = .currency
			formatter.maximumFractionDigits = 0
			let formattedSalary = formatter.string(from: NSNumber(value: Double(salary)))
			if let quickField = QuickFieldView.create(title: "Salary", body: formattedSalary!) {
				firstQuickStackView.addArrangedSubview(quickField)
			}
		}
		
		// Set the experience label
		if let experience = self.job?.experience {
			if let quickField = QuickFieldView.create(title: "Experience", body: "\(experience) yrs") {
				firstQuickStackView.addArrangedSubview(quickField)
			}
		}
		
		// Add the second quick stack view to the field stack view
		let secondQuickStackView = UIStackView()
		secondQuickStackView.axis = .horizontal
		secondQuickStackView.distribution = .fillEqually
		secondQuickStackView.alignment = .fill
		secondQuickStackView.hero.id = "secondQuickStackView"
		
		// Add the first quick stack view to the field stack view
		self.fieldsStackView.addArrangedSubview(secondQuickStackView)
		
		// Set the education label
		if let educations = self.job?.educationLevel {
			if let quickField = QuickFieldView.create(title: "Education", body: "\(educationArray[(educations.last?.rawValue)!])") {
				secondQuickStackView.addArrangedSubview(quickField)
			}
		}
		
		// Set the recent hires label
		if let recentHires = self.job?.numberOfHires {
			if let quickField = QuickFieldView.create(title: "Recent Hires", body: "\(recentHires)") {
				secondQuickStackView.addArrangedSubview(quickField)
			}
		}
		
		// Set the job description for both card and full view
		if let description = self.job?.description_p {
			if let field = FieldView.create(title: "Job Description", body: description) {
				self.fieldsStackView.addArrangedSubview(field)
			}
		}
		
		// Create the field view for job description
		if presentationType == .Full {
			// Set the annotation on the map
			if let address = self.job?.location.address.streetAddress, let state = self.job?.location.address.state, let zip = self.job?.location.address.zip {
				let locationString = "\(address), \(state), \(zip)"
				let geocoder = CLGeocoder()
				geocoder.geocodeAddressString(locationString) { placemarks, error in
					if let placemark = placemarks?.first, let location = placemark.location {
						let annotation = MKPointAnnotation()
						annotation.coordinate = location.coordinate
						annotation.title = self.job?.company.name
						let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
						let region = MKCoordinateRegion.init(center: location.coordinate, span: span)
						self.mapView.setRegion(region, animated: true)
						self.mapView.addAnnotation(annotation)
					}
				}
			}

			// Set the responsibilities
			if let responsibilities = self.job?.responsibilities {
				if let field = FieldView.create(title: "Responsibilities", body: responsibilities) {
					self.fieldsStackView.addArrangedSubview(field)
				}
			}
			
			// Set the education
			if let education = self.job?.educationLevel {
				var output = ""
				for level in education {
					output += educationArray[level.rawValue]
				}
				
				if let field = FieldView.create(title: "Education", body: output) {
					self.fieldsStackView.addArrangedSubview(field)
				}
			}
			
			// Set the required experience
			if let requiredExperience = self.job?.requiredExperience {
				if let field = FieldView.create(title: "Required Experience", body: requiredExperience) {
					self.fieldsStackView.addArrangedSubview(field)
				}
			}
			
			// Set the preferred experience
			if let preferredExperience = self.job?.preferredExperience {
				if let field = FieldView.create(title: "Preferred Experience", body: preferredExperience) {
					self.fieldsStackView.addArrangedSubview(field)
				}
			}
			
			// Set the tags
			if let tagList = self.tagListView {
				tagList.textFont = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
				if let skills = self.job?.skills {
					for skill in skills {
						tagList.addTag(skill)
					}
				}
			}
		}
		
		// Set the recruiter label
		if let firstName = self.job?.recruiter.firstName, let lastName = self.job?.recruiter.lastName {
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
