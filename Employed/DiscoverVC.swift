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

class DiscoverVC: UIViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var kolodaView: KolodaView!
	
	var jobs = [Employed_Io_Job]()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Remove 1px line below navigation bar
		navigationController?.navigationBar.shadowImage = UIImage()

		// Setup the card view
        self.kolodaView.dataSource = self
		self.kolodaView.delegate = self

		var request = Employed_Io_JobsByTagsRequest()
		request.tags = [""]
		// Call the API service to get jobs
		APIService.shared.getJobsByTags(request: request) { jobsResponse in
			self.jobs = jobsResponse.jobs
			
			// Reload the koloda view with the jobs
			self.kolodaView.reloadData()
		}
		
		APIService.shared.getMockJobs(completion: { job in
			self.jobs.append(job)
			APIService.shared.getMockJobs(completion: { job in
				self.jobs.append(job)
				print(job)
				self.kolodaView.reloadData()
			})
		})
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
			request.matchUserID = self.jobs[index].recruiter.userID
			
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
			var users = [String]()
			APIService.shared.createMatch(request: request) { response in
				// If the match we swiped on previously swiped on us, a connection has been made
				// and we should show the MatchVC
				if response.status == .success {
					users = response.match.users
				
					let matchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MatchVC") as! MatchVC
					matchVC.setMatchName(name: users.last)
					self.customPresentViewController(presenter, viewController: matchVC, animated: true, completion: nil)
				}
			}
		} else if direction == SwipeResultDirection.left {
			// Create the match reject request object
			var request = Employed_Io_RejectMatchRequest()
			request.userID = AccountManager.shared.getUserId()
			request.matchUserID = self.jobs[index].recruiter.userID
			
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
			controller.setJob(job: jobs[index])
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
		return self.jobs.count
	}
	
	func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
		return .fast
	}
	
	func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "DiscoverCardProfileVC") as! DiscoverProfileVC
		if self.jobs.count > index {
			controller.setJob(job: self.jobs[index])
			controller.setPresentationType(type: .Card)
		}
		controller.view.layer.cornerRadius = 10
		controller.view.layer.masksToBounds = true
		return controller.view
	}
}
