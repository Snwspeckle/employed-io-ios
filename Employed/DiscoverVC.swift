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

	// MARK: IBOutlets
	@IBOutlet weak var kolodaView: KolodaView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		// Setup the card view
        kolodaView.dataSource = self
		kolodaView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - KolodaViewDelegate
extension DiscoverVC : KolodaViewDelegate {

	func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
		print ("Did Run Out Of Cards!")
	}
	
	func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
		print("Did Select Card!")
		let verticalPageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"DiscoverPageContainerVC");
		let presenter: Presentr = {
			let width = ModalSize.fluid(percentage: 0.90)
			let height = ModalSize.fluid(percentage: 0.90)
			let customType = PresentationType.custom(width: width, height: height, center: ModalCenterPosition.center)

			let customPresenter = Presentr(presentationType: customType)
			customPresenter.transitionType = .coverVertical
			customPresenter.dismissTransitionType = .crossDissolve
			customPresenter.roundCorners = true
			customPresenter.cornerRadius = 10
			customPresenter.blurBackground = true
//			customPresenter.blurStyle = UIBlurEffectStyle.light
			customPresenter.dismissOnSwipe = true
			customPresenter.dismissOnSwipeDirection = .top
			return customPresenter
		}()
//		let presenter = Presentr(presentationType: .fullScreen)
		self.customPresentViewController(presenter, viewController: verticalPageVC, animated: true, completion: nil)
	}
}

// MARK: - KolodaViewDataSource
extension DiscoverVC : KolodaViewDataSource {

	func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
		return 2
	}
	
	func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
		return .fast
	}
	
	func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
		let storyboard = UIStoryboard(name: "Main", bundle: nil)
		let controller = storyboard.instantiateViewController(withIdentifier: "DiscoverPageContainerVC")
		return controller.view
	}
}
