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
		
		// Get jobs from the API Service
		APIService.shared.getJobs(id: 1) { job1 in
			self.jobs.append(job1)
			print(job1)
			APIService.shared.getJobs(id: 2) { job2 in
				self.jobs.append(job2)
				print(job2)
				APIService.shared.getJobs(id: 3) { job3 in
					self.jobs.append(job3)
					print(job3)
					self.kolodaView.reloadData()
				}
			}
		}
    }
    
	@IBAction func filterButtonPressed(_ sender: Any) {
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
			
			let matchVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"MatchVC") as! MatchVC
			self.customPresentViewController(presenter, viewController: matchVC, animated: true, completion: nil)
		}
	}
	
	func koloda(_ koloda: KolodaView, didShowCardAt index: Int) {
		// Enable hero on the view that is shown on top
		if let view = koloda.viewForCard(at: index) {
			view.hero.isEnabled = true
		}
	}
	
	func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
		if let profileVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"DiscoverFullProfileVC") as? DiscoverProfileVC {
			profileVC.setJob(job: jobs[index])
			if (koloda.currentCardIndex == index) {
				profileVC.hero.isEnabled = true
				profileVC.view.hero.isEnabled = true
			}
			self.present(profileVC, animated: true, completion: nil)
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
		}
		controller.view.layer.cornerRadius = 10
		controller.view.layer.masksToBounds = true
		return controller.view
	}
}
