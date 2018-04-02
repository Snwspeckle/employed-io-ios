//
//  SkillSelectionVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/28/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import Presentr
import TagListView

class SkillSelectionVC: UIViewController {

	var skills = ["Designs", "Development", "Photography", "Artist", "Management", "Business", "Copy Writing", "PRD", "Testing", "Marketing", "QA", "iOS", "SEO"]
	var selectedSkills: [String] = []
	
	@IBOutlet weak var tagListView: TagListView!
	
	var request: Employed_Io_CreateUserRequest!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        self.navigationItem.title = "Select Your Skills"
		self.navigationController?.navigationBar.tintColor = UIColor.white
		
		self.tagListView.delegate = self
		self.tagListView.alignment = .center
		
		// Set the tags
		self.tagListView.textFont = UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.bold)
		for tag in skills {
			self.tagListView.addTag(String(tag).uppercased())
		}
		
		// Initially alpha out the tags
		for tag in self.tagListView.tagViews {
			tag.alpha = 0.0
		}
    }
	
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Alpha in each tag with a random duration between 0.1 - 0.7
		for tag in self.tagListView.tagViews {
			let duration = (Double(arc4random()) / 0xFFFFFFFF) * (0.7 - 0.1) + 0.1
			UIView.animate(withDuration: duration, animations: {
				tag.alpha = 1.0
			})
		}
	}
	
	// Action called when the "Next" button is pressed
	@IBAction func nextButtonPressed(_ sender: Any) {
//		let presenter: Presentr = {
//			let presenter = Presentr(presentationType: .dynamic(center: .center))
//			let animation = ScaleOutwardAnimation(options: .spring(duration: 0.5, delay: 0.0, damping: 0.8, velocity: 1.0))
//			presenter.transitionType = .custom(animation)
//			presenter.dismissOnTap = false
//			return presenter
//		}()
//		customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
		
		// Set the job seekers skills
		self.request.jobSeeker.skills = self.selectedSkills
		self.request.jobSeeker.tags = self.selectedSkills

		AccountManager.shared.createUser(request: self.request) {
			let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"RootTabBar")
			self.present(controller, animated: true, completion: nil)
		}
	}
	
	func setRequest(request: Employed_Io_CreateUserRequest) {
		self.request = request
	}
}

// MARK: TagListView Delegate
extension SkillSelectionVC: TagListViewDelegate {

	func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
		if (tagView.tagBackgroundColor == UIColor.clear) {
			tagView.tagBackgroundColor = UIColor.white
			tagView.textColor = UIColor.darkGray
			
			// Add the skill to the selectedSkills array
			selectedSkills.append(title)
		} else {
			tagView.tagBackgroundColor = UIColor.clear
			tagView.textColor = UIColor.white
			
			// Remove the skill from the selectedSkills array
			if let index = selectedSkills.index(of: title) {
				selectedSkills.remove(at: index)
			}
		}
	}
}

// Custom animation that scales and alphas in the animating view
class ScaleOutwardAnimation: PresentrAnimation {
	
	override func beforeAnimation(using transitionContext: PresentrTransitionContext) {
		transitionContext.animatingView?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
		transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 0.0 : 1.0
	}
	
	override func performAnimation(using transitionContext: PresentrTransitionContext) {
		transitionContext.animatingView?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
		transitionContext.animatingView?.alpha = transitionContext.isPresenting ? 1.0 : 0.0
	}
}
