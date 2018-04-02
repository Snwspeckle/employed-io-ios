//
//  DiscoverVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/7/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit
import Hero
import Koloda
import Presentr
import SwiftProtobuf

class DiscoverVC: UIViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var kolodaView: KolodaView!
	
	var data = [Message]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Remove 1px line below navigation bar
		navigationController?.navigationBar.shadowImage = UIImage()

		// Setup the card view
        self.kolodaView.dataSource = self
		self.kolodaView.delegate = self

		switch AccountManager.shared.getUserRole() {
			case .jobSeeker:
				var request = Employed_Io_JobsByTagsRequest()
				request.tags = (AccountManager.shared.getJobSeeker()?.tags)!
				// Call the API service to get jobs
				APIService.shared.getJobsByTags(request: request) { jobsResponse in
					self.data = jobsResponse.jobs
					
					// Reload the koloda view with the jobs
					self.kolodaView.reloadData()
				}
				
			case .recruiter:
				var request = Employed_Io_JobSeekersByTagsRequest()
				request.tags = ["BUSINESS"]
				// Call the API service to get job seekers
				APIService.shared.getJobSeekersByTags(request: request) { jobseekersResponse in
					self.data = jobseekersResponse.jobSeekers
					
					// Reload the koloda view with the jobs
					self.kolodaView.reloadData()
				}
			case .UNRECOGNIZED(_): return
		}
    }
}

// MARK: - KolodaViewDelegate
extension DiscoverVC : KolodaViewDelegate {

	func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
		print ("Did Run Out Of Cards!")
	}
	
	func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
		// Disable hero on the view that is swiped away
		if let view = koloda.viewForCard(at: index) {
			view.hero.isEnabled = false
		}
		
		if direction == SwipeResultDirection.right {
			// Create the match request object
			var request = Employed_Io_CreateMatchRequest()
			request.userID = AccountManager.shared.getUserId()
			switch AccountManager.shared.getUserRole() {
				case .jobSeeker: request.matchUserID = (self.data[index] as! Employed_Io_Job).recruiter.userID
				case .recruiter: request.matchUserID = (self.data[index] as! Employed_Io_JobSeeker).userID
				case .UNRECOGNIZED(_): break
			}
			
			let presenter: Presentr = {
				let width = ModalSize.fluid(percentage: 1.0)
				let height = ModalSize.fluid(percentage: 0.80)
				let customType = PresentationType.custom(width: width, height: height, center: .center)
				
				let presenter = Presentr(presentationType: customType)
				presenter.transitionType = .coverVerticalFromTop
				presenter.dismissTransitionType = .coverVerticalFromTop
				presenter.blurBackground = true
				presenter.dismissOnTap = false
				return presenter
			}()
			
			// Call the API service to create the match
			APIService.shared.createMatch(request: request) { response in
				// If the match we swiped on previously swiped on us, a connection has been made
				// and we should show the MatchVC
				if response.status == .success {
					// Get the name
					switch AccountManager.shared.getUserRole() {
						case .jobSeeker:
							APIService.shared.getRecruiterByUserId(userId: response.match.users.last!) { recruiter in
								let matchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MatchVC") as! MatchVC
								matchVC.setMatchName(name: recruiter.firstName)
								self.customPresentViewController(presenter, viewController: matchVC, animated: true, completion: nil)
							}
						case .recruiter:
							APIService.shared.getJobSeekerByUserId(userId: response.match.users.last!) { jobseeker in
								let matchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MatchVC") as! MatchVC
								matchVC.setMatchName(name: jobseeker.firstName)
								self.customPresentViewController(presenter, viewController: matchVC, animated: true, completion: nil)
							}
						case .UNRECOGNIZED(_): break
					}
				}
			}
		} else if direction == SwipeResultDirection.left {
			// Create the match reject request object
			var request = Employed_Io_RejectMatchRequest()
			request.userID = AccountManager.shared.getUserId()
			switch AccountManager.shared.getUserRole() {
				case .jobSeeker: request.matchUserID = (self.data[index] as! Employed_Io_Job).recruiter.userID
				case .recruiter: request.matchUserID = (self.data[index] as! Employed_Io_JobSeeker).userID
				case .UNRECOGNIZED(_): break
			}
			
			// Call the API service to reject the match
			APIService.shared.rejectMatch(request: request)
		}
	}
	
	func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
		// Enable hero on the view that is shown on top
		if let view = koloda.viewForCard(at: index) {
			view.hero.isEnabled = true
		}
	}
	
	func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
		if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"DiscoverFullProfileVC") as? DiscoverProfileVC {
			// Setup the controller
			controller.setData(data: data[index])
			controller.setPresentationType(type: .Full)
			
			// If the current card is the one we selected, set hero enabled for animations
			if (koloda.currentCardIndex == index) {
				controller.hero.isEnabled = true
				controller.view.hero.isEnabled = true
			}
			self.present(controller, animated: true, completion: nil)
		}
	}
}

// MARK: - KolodaViewDataSource
extension DiscoverVC : KolodaViewDataSource {

	func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
		return self.data.count
	}
	
	func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
		return .fast
	}
	
	func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "DiscoverCardProfileVC") as! DiscoverProfileVC
		if self.data.count > index {
			controller.setData(data: self.data[index])
			controller.setPresentationType(type: .Card)
		}
		controller.view.layer.cornerRadius = 10
		controller.view.layer.masksToBounds = true
		return controller.view
	}
}
