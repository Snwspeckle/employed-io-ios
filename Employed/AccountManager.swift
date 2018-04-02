//
//  AccountManager.swift
//  Employed
//
//  Created by Anthony Vella on 4/1/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import Foundation
import SwiftProtobuf

/**
 Account Manager is a class responsible for maintaining the logged in account
 and all necessary data.
 */
class AccountManager {

	// Singleton of the Account Manager
	static let shared = AccountManager()

	var user: Employed_Io_User!
	var jobSeeker: Employed_Io_JobSeeker?
	var recruiter: Employed_Io_Recruiter?
	var matches = [Employed_Io_Match]()
	
	// MARK: - USER
	func setUser(_ user: Employed_Io_User) {
		self.user = user
	}
	
	func getUser() -> Employed_Io_User {
		return self.user
	}
	
	func getUserId() -> String {
		return self.user.userID
	}
	
	func getUserRole() -> Employed_Io_User.Role {
		return self.user.role
	}
	
	// MARK: - JOBSEEKER
	func setJobSeeker(_ jobSeeker: Employed_Io_JobSeeker) {
		self.jobSeeker = jobSeeker
	}
	
	func getJobSeeker() -> Employed_Io_JobSeeker? {
		return self.jobSeeker
	}
	
	// MARK: - RECRUITER
	func setRecruiter(_ recruiter: Employed_Io_Recruiter) {
		self.recruiter = recruiter
	}
	
	func getRecruiter() -> Employed_Io_Recruiter? {
		return self.recruiter
	}
	
	// MARK: - MATCHES
	func setMatches(_ matches: [Employed_Io_Match]) {
		self.matches = matches
	}
	
	func getMatches() -> [Employed_Io_Match] {
		return self.matches
	}
	
	func login(username: String!, password: String!, completion: @escaping () -> Void) {
		// Create the login request object
		var loginRequest = Employed_Io_LoginRequest()
		loginRequest.login = username
		loginRequest.password = password
		
		// Call the API login endpoint
		APIService.shared.login(request: loginRequest) { loginResponse in
			// Upon login, set the account managers user
			AccountManager.shared.setUser(loginResponse.user)
			
			// Upon login, set the jobseeker or recruiter
			switch AccountManager.shared.getUserRole() {
				case .jobSeeker: AccountManager.shared.setJobSeeker(loginResponse.jobSeeker)
				case .recruiter: AccountManager.shared.setRecruiter(loginResponse.recruiter)
				case .UNRECOGNIZED(_): return
			}
			
			// Create the match request object
			var matchRequest = Employed_Io_MatchesByUserIdsRequest()
			matchRequest.userIds = [AccountManager.shared.getUserId()]
			
			// Get all matches for the user
			APIService.shared.getMatchesByUserId(request: matchRequest) { matchesResponse in
				// Set the matches
				AccountManager.shared.setMatches(matchesResponse.matches)
			}
			
			// Signal completion of login
			completion()
		}
	}
	
	func createUser(request: Employed_Io_CreateUserRequest, completion: @escaping () -> Void) {
		// Call the API create user endpoint
		APIService.shared.createUser(request: request) { response in
			// Upon account creation, set the account managers user
			AccountManager.shared.setUser(response.user)
			
			// Upon account creation, set the jobseeker or recruiter
			switch AccountManager.shared.getUserRole() {
				case .jobSeeker: AccountManager.shared.setJobSeeker(response.jobSeeker)
				case .recruiter: AccountManager.shared.setRecruiter(response.recruiter)
				case .UNRECOGNIZED(_): return
			}
			
			// Signal completion of user creation
			completion()
		}
	}
}
