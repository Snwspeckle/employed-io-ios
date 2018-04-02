//
//  MatchVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/5/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

class MatchVC: UIViewController {

	// Margin constant for the trailing & leading constraints of the image views
	static let IMAGE_VIEW_MARGIN = CGFloat(40)
	
	// StackView containing the various text
	@IBOutlet weak var textStackView: UIStackView!
	@IBOutlet weak var connectionNameLabel: UILabel!
	
	// ImageView for the local logged in user
	@IBOutlet weak var localImageView: UIImageView!
	@IBOutlet weak var localImageViewLeadingConstraint: NSLayoutConstraint!
	// ImageView for the remote user we connected with
	@IBOutlet weak var connectionImageView: UIImageView!
	@IBOutlet weak var connectionImageViewTrailingConstraint: NSLayoutConstraint!
	@IBOutlet weak var buttonStackView: UIStackView!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set the image views to be circular with a white border
        self.localImageView.clipsToBounds = true
		self.localImageView.layer.cornerRadius = self.localImageView.frame.width / 2
		self.localImageView.layer.borderWidth = 3
		self.localImageView.layer.borderColor = UIColor.white.cgColor
		self.connectionImageView.clipsToBounds = true
		self.connectionImageView.layer.cornerRadius = self.connectionImageView.frame.width / 2
		self.connectionImageView.layer.borderWidth = 3
		self.connectionImageView.layer.borderColor = UIColor.white.cgColor

        // Set all the views to the initial animation state
        self.textStackView.alpha = 0.0
        self.localImageViewLeadingConstraint.constant = -self.localImageView.frame.width
        self.connectionImageViewTrailingConstraint.constant = -self.connectionImageView.frame.width
        self.buttonStackView.alpha = 0.0
    }
	
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Animate the image views into position
		UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 4, options: .curveEaseInOut, animations: {
			self.localImageViewLeadingConstraint.constant = MatchVC.IMAGE_VIEW_MARGIN
			self.connectionImageViewTrailingConstraint.constant = MatchVC.IMAGE_VIEW_MARGIN
			self.view.layoutIfNeeded()
		}) { _ in
			// Animate the text & button stackviews after image views have finished animating
			UIView.animate(withDuration: 0.5, animations: {
				self.textStackView.alpha = 1.0
				self.buttonStackView.alpha = 1.0
			})
		}
	}
	
	// Action called when the "Message" button is pressed
	@IBAction func messageButtonPressed(_ sender: Any) {
	}
	
	// Action called when the "Continue" button is pressed
	@IBAction func continueButtonPressed(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}
	
	func setMatchName(name: String!) {
		self.connectionNameLabel.text = name
	}
}
