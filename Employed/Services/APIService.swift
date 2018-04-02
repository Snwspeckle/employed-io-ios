//
//  APIService.swift
//  Employed
//
//  Created by Anthony Vella on 11/9/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import Foundation
import Networking
import SwiftProtobuf

/**
 API Service is a class responsible for the networking of all requests
 to the backend API
 */
class APIService {

	// Singleton of the Network Service
	static let shared = APIService()
	
	enum RequestType {
        case get
        case post
    }

	// Base URL of the API endpoints
//	private let baseURL: String = "http://127.0.0.1:8080";
	private let baseURL: String = "http://192.168.43.168:8080";

	private init() {
	}
	
	// MARK: - AUTHENTICATION
	
	func login(request: Employed_Io_LoginRequest, completion: ((Employed_Io_LoginResponse) -> Void)?) {
		makeRequest(endpoint: "/login", requestType: .post, request: request) { data in
			do {
				completion?(try Employed_Io_LoginResponse(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	// MARK: - USERS
	
	func createUser(request: Employed_Io_CreateUserRequest, completion: ((Employed_Io_CreateUserResponse) -> Void)?) {
		makeRequest(endpoint: "/users/create", requestType: .post, request: request) { data in
			do {
				completion?(try Employed_Io_CreateUserResponse(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	// MARK: - JOB SEEKER
	
	func getJobSeekersByTags(request: Employed_Io_JobSeekersByTagsRequest, completion: ((Employed_Io_JobSeekersByTagsResponse) -> Void)?) {
		makeRequest(endpoint: "/jobseekers", requestType: .post, request: request) { data in
			do {
				completion?(try Employed_Io_JobSeekersByTagsResponse(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	func getJobSeekerByUserId(userId: String, completion: ((Employed_Io_JobSeeker) -> Void)?) {
		makeRequest(endpoint: "/jobseekers/\(userId)", requestType: .get) { data in
			do {
				completion?(try Employed_Io_JobSeeker(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	// MARK: - RECRUITER
	
	func getRecruiterByUserId(userId: String, completion: ((Employed_Io_Recruiter) -> Void)?) {
		makeRequest(endpoint: "/recruiters/\(userId)", requestType: .get) { data in
			do {
				completion?(try Employed_Io_Recruiter(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	// MARK: - JOBS
	
	func getJobsByTags(request: Employed_Io_JobsByTagsRequest, completion: ((Employed_Io_JobsByTagsResponse) -> Void)?) {
		makeRequest(endpoint: "/jobs", requestType: .post, request: request) { data in
			do {
				completion?(try Employed_Io_JobsByTagsResponse(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	func getMockJobs(completion: ((Employed_Io_Job) -> Void)?) {
		makeRequest(endpoint: "/jobs/mock", requestType: .post) { data in
			do {
				completion?(try Employed_Io_Job(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	// MARK: - MATCHES
	
	func getMatches(completion: ((Employed_Io_MatchesResponse) -> Void)?) {
		makeRequest(endpoint: "/match", requestType: .get) { data in
			do {
				completion?(try Employed_Io_MatchesResponse(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	func getMatchesByUserId(request: Employed_Io_MatchesByUserIdsRequest, completion: ((Employed_Io_MatchesByUserIdsResponse) -> Void)?) {
		makeRequest(endpoint: "/match", requestType: .post, request: request) { data in
			do {
				completion?(try Employed_Io_MatchesByUserIdsResponse(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	func createMatch(request: Employed_Io_CreateMatchRequest, completion: ((Employed_Io_CreateMatchResponse) -> Void)?) {
		makeRequest(endpoint: "/match/create", requestType: .post, request: request) { data in
			do {
				// Update our local cache of matches
				AccountManager.shared.updateMatches(completion: nil)
				
				completion?(try Employed_Io_CreateMatchResponse(jsonUTF8Data: data))
			} catch {
				return
			}
		}
	}
	
	func rejectMatch(request: Employed_Io_RejectMatchRequest) {
		makeRequest(endpoint: "/match/reject", requestType: .post, request: request, completion: nil)
		
		// Update our local cache of matches
		AccountManager.shared.updateMatches(completion: nil)
	}
	
	// MARK: - INTERNAL FUNCTIONS
	
	private func makeRequest(endpoint: String, requestType: RequestType, completion: ((Data) -> Void)?) {
		makeRequest(endpoint: endpoint, requestType: requestType, request: nil) { data in
			completion?(data)
		}
	}
	
	private func makeRequest(endpoint: String, requestType: RequestType, request: Message?, completion: ((Data) -> (Void))?) {
		// Create our networking manager
		let networking = Networking(baseURL: baseURL)
		
		// Setup our headers for the request
		setupHeaders(networking: networking)
		
		// Determine what type of request is being made
		switch requestType {
		case .get:
			do {
				networking.get("/api\(endpoint)", parameters: try request?.serializedData()) { result in
					self.handleRequest(result: result) { data in completion?(data) }
				}
			} catch {
				return
			}
		case .post:
			do {
				networking.post("/api\(endpoint)", parameterType: .custom("application/x-protobuf"), parameters: try request?.serializedData()) { result in
					self.handleRequest(result: result) { data in completion?(data) }
				}
			} catch {
				return
			}
		}
	}
	
	private func handleRequest(result: JSONResult, completion: (Data) -> Void) {
		switch result {
		case .success(let response):
			completion(response.data)
		case .failure(_):
			return
		}
	}
	
	private func setupHeaders(networking: Networking) -> Void {
		networking.headerFields = ["Accept": "application/json"]
	}
}
