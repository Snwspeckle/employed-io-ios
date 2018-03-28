//
//  FieldView.swift
//  Employed
//
//  Created by Anthony Vella on 3/26/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

/**
 FieldView is a reusable view that can be populated with a title
 and body to be added so a vertical UIStackView. This is commonly
 used in the Discover card views.
 */
class FieldView: ProfileSectionView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	
    override init(frame: CGRect) {
    	super.init(frame: frame)
	}
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
    static func create(title: String, body: String) -> FieldView? {
		let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"FieldVC")
		if let view = controller.view as? FieldView {
			view.titleLabel.text = title
			view.titleLabel.hero.id = title
			view.bodyLabel.text = body
			view.bodyLabel.hero.id = title + "Body"
			return view
		}
		return nil
	}
}
