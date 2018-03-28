//
//  FieldView.swift
//  Employed
//
//  Created by Anthony Vella on 3/26/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

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
			view.bodyLabel.text = body
			return view
		}
		return nil
	}
}
