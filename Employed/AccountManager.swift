//
//  AccountManager.swift
//  Employed
//
//  Created by Anthony Vella on 4/1/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import Foundation

/**
 Account Manager is a class responsible for maintaining the logged in account
 and all necessary data.
 */
class AccountManager {

	// Singleton of the Account Manager
	static let shared = AccountManager()

	var user: Employed_Io_User!
	
	func setUser(_ user: Employed_Io_User) {
		self.user = user
	}
	
	func getUser() -> Employed_Io_User {
		return self.user
	}
	
	func login(username: String!, password: String!, completion: @escaping () -> Void) {
		// Create the login request object
		var request = Employed_Io_LoginRequest()
		request.login = username
		request.password = password
		
		// Call the API login endpoint
		APIService.shared.login(request: request) { response in
			// Upon login, set the account managers user
			AccountManager.shared.setUser(response.user)
			
			// Signal completion of login
			completion()
		}
	}
}
