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
import Networking
import SwiftProtobuf
import TagListView

// Declaration of the two different presentation styles for this view
enum DiscoverProfilePresentationType {
	case Card
	case Full
}

class DiscoverProfileVC: UIViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var subtitleLabel: UILabel!
	@IBOutlet weak var mapView: MKMapView!
	
	@IBOutlet weak var fieldsStackView: UIStackView!
	
	@IBOutlet weak var tagListView: TagListView!
	
	@IBOutlet weak var recruiterImageView: UIImageView!
	@IBOutlet weak var recruiterNameLabel: UILabel!
	
	var recruiterImage: String!
	
	var data: Message?
	
	// The presentation type of this view controller. Presentation type represents whether
	// this view controller is being displayed in a card or full form.
	var presentationType: DiscoverProfilePresentationType = .Card
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set the company picture
        // NOTE: This is temporarily fixed as we aren't loading images from the network yet
//        self.pictureImageView.image = UIImage(named: "ecorp")
        self.pictureImageView.clipsToBounds = true
        self.pictureImageView.layer.cornerRadius = self.pictureImageView.frame.width / 2
		
        switch AccountManager.shared.getUserRole() {
        	case .jobSeeker:
        		// Cast the message to the proper type
        		let job = self.data as! Employed_Io_Job
				
				// Set the company picture
        		let networking = Networking(baseURL: job.company.avatarURL)
				networking.downloadImage("") { result in
					switch result {
						case let .success(response):
							self.pictureImageView.image = response.image
						case .failure:
							break
						}
				}
			
        		// Set the title label
				self.titleLabel.text = job.title
				
				// Set the subtitle label
				self.subtitleLabel.text = job.company.name
			
				// Set the first quick stack view
				let firstQuickStackView = UIStackView()
				firstQuickStackView.axis = .horizontal
				firstQuickStackView.distribution = .fillEqually
				firstQuickStackView.alignment = .fill
				firstQuickStackView.hero.id = "firstQuickStackView"
				
				// Add the first quick stack view to the field stack view
				self.fieldsStackView.addArrangedSubview(firstQuickStackView)
				
				// Set the location label
				if let quickField = QuickFieldView.create(title: "Location", body: job.location.address.city + ", " + job.location.address.state) {
					firstQuickStackView.addArrangedSubview(quickField)
				}
				
				// Set the salary label
				let formatter = NumberFormatter()
				formatter.numberStyle = .currency
				formatter.maximumFractionDigits = 0
				let formattedSalary = formatter.string(from: NSNumber(value: Double(job.salary)))
				if let quickField = QuickFieldView.create(title: "Salary", body: formattedSalary!) {
					firstQuickStackView.addArrangedSubview(quickField)
				}
				
				// Set the experience label
				if let quickField = QuickFieldView.create(title: "Experience", body: "\(job.experience) yrs") {
					firstQuickStackView.addArrangedSubview(quickField)
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
				if let quickField = QuickFieldView.create(title: "Education", body: "\(educationArray[(job.educationLevel.last?.rawValue)!])") {
					secondQuickStackView.addArrangedSubview(quickField)
				}
				
				// Set the recent hires label
				if let quickField = QuickFieldView.create(title: "Recent Hires", body: "\(job.numberOfHires)") {
					secondQuickStackView.addArrangedSubview(quickField)
				}
				
				// Set the job description for both card and full view
				if let field = FieldView.create(title: "Job Description", body: job.description_p) {
					self.fieldsStackView.addArrangedSubview(field)
				}
			
				// Create the field view for job description
				if presentationType == .Full {
					// Set the annotation on the map
					let locationString = "\(job.location.address.streetAddress), \(job.location.address.state), \(job.location.address.zip)"
					let geocoder = CLGeocoder()
					geocoder.geocodeAddressString(locationString) { placemarks, error in
						if let placemark = placemarks?.first, let location = placemark.location {
							let annotation = MKPointAnnotation()
							annotation.coordinate = location.coordinate
							annotation.title = job.company.name
							let span = MKCoordinateSpan.init(latitudeDelta: 0.005, longitudeDelta: 0.005)
							let region = MKCoordinateRegion.init(center: location.coordinate, span: span)
							self.mapView.setRegion(region, animated: true)
							self.mapView.addAnnotation(annotation)
						}
					}

					// Set the responsibilities
					if let field = FieldView.create(title: "Responsibilities", body: job.responsibilities) {
						self.fieldsStackView.addArrangedSubview(field)
					}
					
					// Set the education
					var output = ""
					for level in job.educationLevel {
						output += educationArray[level.rawValue]
					}
					
					if let field = FieldView.create(title: "Education", body: output) {
						self.fieldsStackView.addArrangedSubview(field)
					}
					
					// Set the required experience
					if let field = FieldView.create(title: "Required Experience", body: job.requiredExperience) {
						self.fieldsStackView.addArrangedSubview(field)
					}
					
					// Set the preferred experience
					if let field = FieldView.create(title: "Preferred Experience", body: job.preferredExperience) {
						self.fieldsStackView.addArrangedSubview(field)
					}
					
					// Set the tags
					if let tagList = self.tagListView {
						tagList.textFont = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
						for skill in job.skills {
							tagList.addTag(skill)
						}
					}
				}
			
				// Set the recruiter label
				self.recruiterNameLabel.text = job.recruiter.firstName + " " + job.recruiter.lastName
				
				switch job.recruiter.firstName {
					case "Angela": self.recruiterImage = "angela_moss"
					case "Tyrell": self.recruiterImage = "tyrell_wellick"
					case "Phillip": self.recruiterImage = "phillip_price"
					default: self.recruiterImage = "angela_moss"
				}
        	case .recruiter:
        		// Cast the message to the proper type
        		let jobseeker = self.data as! Employed_Io_JobSeeker
				
        		// Set the users picture
				self.pictureImageView.image = UIImage(named: "angela_moss")
			
        		// Set the title label
				self.titleLabel.text = jobseeker.firstName + " " + jobseeker.lastName
			
				// Set the subtitle label
				self.subtitleLabel.text = jobseeker.currentPosition
				
				// Set the first quick stack view
				let firstQuickStackView = UIStackView()
				firstQuickStackView.axis = .horizontal
				firstQuickStackView.distribution = .fillEqually
				firstQuickStackView.alignment = .fill
				firstQuickStackView.hero.id = "firstQuickStackView"
				
				// Add the first quick stack view to the field stack view
				self.fieldsStackView.addArrangedSubview(firstQuickStackView)
				
				if let quickField = QuickFieldView.create(title: "Preferred Industry", body: "\(industriesArray[(jobseeker.industry.rawValue)])") {
					firstQuickStackView.addArrangedSubview(quickField)
				}
				
				// Set the headline
				if let field = FieldView.create(title: "Headline", body: jobseeker.headline) {
					self.fieldsStackView.addArrangedSubview(field)
				}
				
				// Set the bio
				if let field = FieldView.create(title: "Bio", body: jobseeker.bio) {
					self.fieldsStackView.addArrangedSubview(field)
				}
				
				// Set the email
				if let field = FieldView.create(title: "Email", body: jobseeker.email) {
					self.fieldsStackView.addArrangedSubview(field)
				}
				
				self.recruiterImageView.isHidden = true
				self.recruiterNameLabel.isHidden = true
				self.recruiterImage = "tyrell_wellick"
        	case .UNRECOGNIZED(_): return
		}
		
		// Set the recruiter picture
		// NOTE: This is temporarily fixed as we aren't loading images from the network yet
		self.recruiterImageView.image = UIImage(named: self.recruiterImage)
		self.recruiterImageView.clipsToBounds = true
		self.recruiterImageView.layer.cornerRadius = self.recruiterImageView.frame.width / 2
    }
	
	// Set the data object
	func setData(data: Message) -> Void {
		self.data = data
	}
	
	// Sets the presentation type
	func setPresentationType(type: DiscoverProfilePresentationType) -> Void {
		self.presentationType = type
	}
}
