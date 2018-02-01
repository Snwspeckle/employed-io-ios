//
//  DiscoverVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/7/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit
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
	
	func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
		let containerVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"DiscoverPageContainerVC") as! DiscoverPageContainerVC
		
		// Set the job model to the page container
		containerVC.setJob(job: jobs[index])
		
		let presenter: Presentr = {
			let width = ModalSize.fluid(percentage: 0.90)
			let height = ModalSize.fluid(percentage: 0.90)
			let customType = PresentationType.custom(width: width, height: height, center: .center)

			let customPresenter = Presentr(presentationType: customType)
			customPresenter.transitionType = .coverVertical
			customPresenter.dismissTransitionType = .crossDissolve
			customPresenter.roundCorners = true
			customPresenter.cornerRadius = 10
			customPresenter.blurBackground = true
			customPresenter.dismissOnTap = true
			customPresenter.dismissOnSwipe = false
			return customPresenter
		}()
		presenter.viewControllerForContext = self
		self.customPresentViewController(presenter, viewController: containerVC, animated: true, completion: nil)
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
		let controller = storyboard.instantiateViewController(withIdentifier: "DiscoverCardProfileNEWVC") as! DiscoverCardProfileNEWVC
		if self.jobs.count > index {
			controller.setJob(job: self.jobs[index])
		}
		controller.view.layer.cornerRadius = 10
		controller.view.layer.masksToBounds = true
		return controller.view
	}
}
