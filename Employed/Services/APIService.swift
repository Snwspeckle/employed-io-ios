//
//  APIService.swift
//  Employed
//
//  Created by Anthony Vella on 11/9/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import Foundation
import Networking

/**
 API Service is a class responsible for the networking of all requests
 to the backend API
 */
class APIService {

	// Singleton of the Network Service
	static let shared = APIService()

	// Base URL of the API endpoints
	private let baseURL: String = "http://127.0.0.1:8080";

	private init() {
	}

	func getUser(email: String, completion: @escaping (Employed_Io_User) -> Void) {
		let networking = Networking(baseURL: baseURL)
		// Setup our headers for the request
		setupHeaders(networking: networking)
		networking.get("/api/user", parameters: ["email": email]) { result in
			switch result {
			case .success(let response):
				do {
					let user = try Employed_Io_User(jsonUTF8Data: response.data)
					completion(user)
				} catch {
					return ()
				}
			case .failure(_):
				return ()
			}
		}
	}
	
	func getJobs(id: Int, completion: @escaping (Employed_Io_Job) -> Void) {
		let networking = Networking(baseURL: baseURL)
		// Setup our headers for the request
		setupHeaders(networking: networking)
		networking.get("/api/jobs/\(id)") { result in
			switch result {
			case .success(let response):
				do {
					let job = try Employed_Io_Job(jsonUTF8Data: response.data)
					completion(job)
				} catch {
					return ()
				}
			case .failure(_):
				return ()
			}
		}
	}
	
	func getMockUsers(completion: @escaping (Employed_Io_User) -> Void) {
		let networking = Networking(baseURL: baseURL)
		// Setup our headers for the request
		setupHeaders(networking: networking)
		networking.post("/api/users/test") { result in
			switch result {
			case .success(let response):
				do {
					let user = try Employed_Io_User(jsonUTF8Data: response.data)
					completion(user)
				} catch {
					return ()
				}
			case .failure(_):
				return ()
			}
		}
	}
	
	func getMockJobs(completion: @escaping (Employed_Io_Job) -> Void) {
		let networking = Networking(baseURL: baseURL)
		// Setup our headers for the request
		setupHeaders(networking: networking)
		networking.post("/api/jobs/mock") { result in
			switch result {
			case .success(let response):
				do {
					let job = try Employed_Io_Job(jsonUTF8Data: response.data)
					completion(job)
				} catch {
					return ()
				}
			case .failure(_):
				return ()
			}
		}
	}
	
	private func setupHeaders(networking: Networking) -> Void {
		networking.headerFields = ["Accept": "application/json"]
	}
}
