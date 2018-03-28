//
//  AccountsVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/6/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import Presentr

// The custom cell for the accounts table view
class AccountsTableViewCell: UITableViewCell {

	@IBOutlet weak var accountImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var accountTypeLabel: UILabel!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		// Style the account image view
		self.accountImageView.clipsToBounds = true
		self.accountImageView.layer.cornerRadius = self.accountImageView.frame.width / 2
	}
	
	func setup(_ account: Account) {
		self.accountImageView.image = account.avatar
		self.nameLabel.text = account.name
		self.accountTypeLabel.text = account.accountType
	}
}

// Helper struct for the table view data
struct Account {
	var avatar: UIImage
	var name: String
	var accountType: String
}

class AccountsVC: UITableViewController {

	var accounts: [Account] = []

    override func viewDidLoad() {
        super.viewDidLoad()
		
		let jobseeker = Account(avatar: UIImage(named: "angela_moss")!, name: "AngelaMoss", accountType: "Job Seeker")
		let recruiter = Account(avatar: UIImage(named: "tyrell_wellick")!, name: "TyrellWellick", accountType: "Recruiter")
		accounts.append(jobseeker)
		accounts.append(recruiter)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsCellIdentifier", for: indexPath) as! AccountsTableViewCell

        // Setup the cell for the account
		cell.setup(accounts[indexPath.row])

        return cell
    }
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let presenter: Presentr = {
			let presenter = Presentr(presentationType: .dynamic(center: .center))
			let animation = ScaleOutwardAnimation(options: .spring(duration: 0.5, delay: 0.0, damping: 0.8, velocity: 1.0))
			presenter.transitionType = .custom(animation)
			presenter.dismissOnTap = false
			return presenter
		}()
		
		// Set the identity of our user
		VideoService.shared.setIdentity(accounts[indexPath.row].name)
		
		let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"RootTabBar")
		self.customPresentViewController(presenter, viewController: controller, animated: true, completion: nil)
		
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
