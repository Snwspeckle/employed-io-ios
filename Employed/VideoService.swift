//
//  VideoService.swift
//  Employed
//
//  Created by Anthony Vella on 3/7/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import Foundation

class VideoService {

	// Singleton of the VideoService
	static let shared = VideoService()
	
	var identity: String!
	
	func setIdentity(_ identity: String) {
		self.identity = identity
	}
	
	func getIdentity() -> String {
		return self.identity
	}
}
