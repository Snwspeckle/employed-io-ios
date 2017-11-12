//
//  ConnectionsTableViewCell.swift
//  Employed
//
//  Created by Anthony Vella on 11/12/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit

class ConnectionsTableViewCell: UITableViewCell {
	
	@IBOutlet weak var pictureImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	
	override func awakeFromNib() {
        super.awakeFromNib()
		
		// Customize the image view to be circular
		self.pictureImageView.clipsToBounds = true
        self.pictureImageView.layer.cornerRadius = self.pictureImageView.frame.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	// Setup the cell with the necessary information
    func setup(image: UIImage, name: String) -> Void {
		self.pictureImageView.image = image
		self.nameLabel.text = name
	}

}
