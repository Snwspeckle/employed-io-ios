//
//  QuickFieldView.swift
//  Employed
//
//  Created by Anthony Vella on 3/31/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

class QuickFieldView: UIView {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var bodyLabel: UILabel!
	
	override init(frame: CGRect) {
    	super.init(frame: frame)
	}
	
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
	
    static func create(title: String, body: String) -> QuickFieldView? {
		let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"QuickFieldVC")
		if let view = controller.view as? QuickFieldView {
			view.titleLabel.text = title.uppercased()
			view.titleLabel.hero.id = title
			view.bodyLabel.text = body
			view.bodyLabel.hero.id = title + "Body"
			return view
		}
		return nil
	}

}
