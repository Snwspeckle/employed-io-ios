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
    func setup(image: UIImage, name: String, companyName: String, jobPosition: String) -> Void {
		self.pictureImageView.image = image
		self.nameLabel.text = name
		self.companyAndJobLabel.text = companyName + ", " + jobPosition
	}
}

class ConnectionsVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionsCellIdentifier", for: indexPath) as! ConnectionsTableViewCell
		
		// Setup the cell
		cell.setup(image: UIImage(named: "tyrell_wellick")!, name: "Tyrell Wellick", companyName: "E-Corp", jobPosition: "Software Engineer I")
		
        return cell
    }
	
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    	// Upon selecting the connection, join the respective chat channel
		ChatService.shared.joinChannel(channel: AccountManager.shared.getMatches()[indexPath.row].channelID, completion: { () in
			// Instantiate a ChatVC and push it on the navigation stack
			let viewcontroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
			self.navigationController?.pushViewController(viewcontroller, animated: true)
		})
	}
}
