//
//  ProfileSectionView.swift
//  Employed
//
//  Created by Anthony Vella on 3/5/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit

/**
 ProfileSectionView is a IBDesignable view that simplifies the
 design process for views by being viewable in a Storyboard
 */
@IBDesignable
class ProfileSectionView: UIView {

	//MARK: - Initialization
	override init(frame: CGRect) {
		super.init(frame: frame)
		sharedInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		sharedInit()
	}

	func sharedInit() {
		updateCornerRadius(cornerRadius)
		updateSectionBackgroundColor(sectionBackgroundColor)
		updateBorderWidth(borderWidth)
		updateBorderColor(borderColor)
		updateShadowRadius(shadowRadius)
		updateShadowOpacity(shadowOpacity)
		updateShadowOffset(shadowOffset)
		updateShadowColor(shadowColor)
	}
	
	@IBInspectable
	var cornerRadius: CGFloat = 2.0 {
		didSet {
			updateCornerRadius(cornerRadius)
		}
	}
	
	@IBInspectable
	var sectionBackgroundColor: UIColor = UIColor.white {
		didSet {
			updateSectionBackgroundColor(sectionBackgroundColor)
		}
	}
	
	@IBInspectable
	var borderWidth: CGFloat = 0.0 {
   		didSet {
   			updateBorderWidth(borderWidth)
   		}
	}
	
	@IBInspectable
	var borderColor: UIColor = UIColor.white {
   		didSet {
   			updateBorderColor(borderColor)
   		}
	}
	
	@IBInspectable
	var shadowRadius: CGFloat = 4.0 {
        didSet {
        	updateShadowRadius(shadowRadius)
		}
    }
	
    @IBInspectable
    var shadowOpacity: Float = 0.15 {
        didSet {
        	updateShadowOpacity(shadowOpacity)
		}
    }
	
    @IBInspectable
    var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
        didSet {
        	updateShadowOffset(shadowOffset)
		}
    }
	
    @IBInspectable
    var shadowColor: UIColor = UIColor.darkGray {
        didSet {
        	updateShadowColor(shadowColor)
		}
    }
	
	//MARK: - Private setter helpers
	fileprivate func updateCornerRadius(_ radius: CGFloat) {
		self.layer.cornerRadius = radius
	}
	
	fileprivate func updateSectionBackgroundColor(_ color: UIColor) {
		self.backgroundColor = color
	}
	
	fileprivate func updateBorderWidth(_ value: CGFloat) {
		self.layer.borderWidth = value
	}

	fileprivate func updateBorderColor(_ color: UIColor) {
		self.layer.borderColor = color.cgColor
	}
	
	fileprivate func updateShadowRadius(_ radius: CGFloat) {
		self.layer.shadowRadius = radius
	}
	
	fileprivate func updateShadowOpacity(_ opacity: Float) {
		self.layer.shadowOpacity = opacity
	}
	
	fileprivate func updateShadowOffset(_ offset: CGSize) {
		self.layer.shadowOffset = offset
	}
	
	fileprivate func updateShadowColor(_ color: UIColor) {
		self.layer.shadowColor = color.cgColor
	}
}
