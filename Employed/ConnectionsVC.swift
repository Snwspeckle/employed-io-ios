//
//  ConnectionsVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/9/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit

class ConnectionsTableViewCell: UITableViewCell {
	
	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var companyAndJobLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		// Customize the image view to be circular
		self.pictureImageView.clipsToBounds = true
        self.pictureImageView.layer.cornerRadius = self.pictureImageView.frame.width / 2
    }
	
	override func setHighlighted(_ highlighted: Bool, animated: Bool) {
		super.setHighlighted(highlighted, animated: animated)
		
		// Customize the highlighted background color
		self.backgroundColor = highlighted ? UIColor(named: "TableViewCell Selected") : UIColor.white
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Customize the selected background color
		self.backgroundColor = selected ? UIColor(named: "TableViewCell Selected") : UIColor.white
	}
	
	// Setup the cell with the necessary information
    func setup(image: UIImage, name: String, companyName: String?, jobPosition: String) -> Void {
		self.pictureImageView.image = image
		self.nameLabel.text = name
		self.companyAndJobLabel.text = (companyName != nil) ? companyName! + ", " + jobPosition : jobPosition
	}
}

class ConnectionsVC: UITableViewController {

	var username: String?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
    override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		AccountManager.shared.updateMatches() {
			self.tableView.reloadData()
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountManager.shared.getMatches().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionsCellIdentifier", for: indexPath) as! ConnectionsTableViewCell
		
		let match = AccountManager.shared.getMatchForId(matchId: indexPath.row)
		
		switch AccountManager.shared.getUserRole() {
			case .jobSeeker:
				APIService.shared.getRecruiterByUserId(userId: (match.users.last)!) { recruiter in
					// Setup the cell
					cell.setup(image: UIImage(named: "tyrell_wellick")!, name: "\(recruiter.firstName) \(recruiter.lastName)", companyName: nil, jobPosition: "")
					self.username = "\(recruiter.firstName) \(recruiter.lastName)"
				}
			case .recruiter:
				APIService.shared.getJobSeekerByUserId(userId: (match.users.first)!) { jobseeker in
					// Setup the cell
					cell.setup(image: UIImage(named: "angela_moss")!, name: "\(jobseeker.firstName) \(jobseeker.lastName)", companyName: nil, jobPosition: jobseeker.currentPosition)
					self.username = "\(jobseeker.firstName) \(jobseeker.lastName)"
				}
			case .UNRECOGNIZED(_): break
		}
		return cell
    }
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    	// Upon selecting the connection, join the respective chat channel
		ChatService.shared.joinChannel(channel: AccountManager.shared.getMatches()[indexPath.row].channelID, completion: { () in
			// Instantiate a ChatVC and push it on the navigation stack
			let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
			controller.setChannelId(channelId: AccountManager.shared.getMatches()[indexPath.row].channelID)
			controller.setNavTitle(title: self.username!)
			self.navigationController?.pushViewController(controller, animated: true)
		})
	}
}
