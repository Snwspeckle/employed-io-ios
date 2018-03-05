//
//  ChatService.swift
//  Employed
//
//  Created by Anthony Vella on 3/4/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import Foundation
import UIKit
import TwilioChatClient

protocol ChatServiceDelegate: class {
	func didReceiveMessage(message: TCHMessage)
}

class ChatService: NSObject {

	// Chat client objects
	var client: TwilioChatClient? = nil
	var channel: TCHChannel? = nil
	
	// ChatService delegate
	weak var delegate: ChatServiceDelegate? = nil
	
	// Twilio Token Function URL
    let tokenURL = "https://aurometalsaurus-frigatebird-8588.twil.io/chat-token"
	
	// Singleton of the ChatService
	static let shared = ChatService()
	
	// Login to the twilio chat service
	func login(identity: String) {
	
		// Fetch Access Token from the server and initialize Chat Client
        let deviceId = UIDevice.current.identifierForVendor!.uuidString
        let urlString = "\(tokenURL)?identity=\(identity)&device=\(deviceId)"
		
        TokenUtils.retrieveToken(url: urlString) { (token, identity, error) in
            if let token = token {
                // Set up Twilio Chat client
                TwilioChatClient.chatClient(withToken: token, properties: nil, delegate: self) {
                    (result, chatClient) in
                        self.client = chatClient;
                    }
            } else {
                print("Error retrieving token: \(error.debugDescription)")
            }
        }
	}
	
	// Logout from the twilio chat service
	func logout() {
        if let client = client {
            client.delegate = nil
            client.shutdown()
            self.client = nil
        }
    }
	
	// Gets the logged in users unique identity
    func getUserIdentity() -> String? {
		return self.client?.user?.identity
	}
	
	// Gets the logged in users friendly name. If a friendly name is not set, default to user identity
	func getUserFriendlyName() -> String? {
		if let name = self.client?.user?.friendlyName {
			return name
		} else {
			return getUserIdentity()
		}
	}
	
	// Joins a channel with the given string
	func joinChannel(channel: String, completion: @escaping () -> Void) {
		if let channelsList = client?.channelsList() {
			channelsList.channel(withSidOrUniqueName: channel, completion: { (result, channel) in
				if let channel = channel {
					// Set the channel to the one joined
					self.channel = channel
					channel.join(completion: { result in
						// Execute the channel join is complete
						completion()
						print("Channel joined with result \(result)")
					})
				}
			})
		}
	}
	
	// Get a list of all TCHMessages for the current joined channel
	func getChannelMessages(completion: @escaping ([TCHMessage]?) -> Void) {
		self.channel?.messages!.getLastWithCount(50, completion: { (result, messages) in
			if let messages = messages {
				completion(messages)
			}
		})
	}
	
	// Sends a message with the body to the channel
	func sendMessage(body: String) {
		let messageOptions = TCHMessageOptions().withBody(body)
		self.channel?.messages?.sendMessage(with: messageOptions, completion: nil)
	}
}

// MARK: Twilio Chat Delegate

extension ChatService: TwilioChatClientDelegate {

	// Called whenever a login is successful
	func chatClient(_ client: TwilioChatClient, synchronizationStatusUpdated status: TCHClientSynchronizationStatus) {
        if status == .completed {
        	print("CHAT SERVICE LOGIN SUCCESS")
        }
    }
	
    // Called whenever a channel we've joined receives a new message
    func chatClient(_ client: TwilioChatClient, channel: TCHChannel, messageAdded message: TCHMessage) {
    	if (message.author! != getUserIdentity()) {
			// Call the chat service protocol
			self.delegate?.didReceiveMessage(message: message)
		}
    }
}

/**
Helper stuct to parse tokens from the token function
*/
struct TokenUtils {
	static func retrieveToken(url: String, completion: @escaping (String?, String?, Error?) -> Void) {
        if let requestURL = URL(string: url) {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:String]
                        let token = json["token"]
                        let identity = json["identity"]
                        completion(token, identity, error)
                    }
                    catch let error as NSError {
                        completion(nil, nil, error)
                    }
                } else {
                    completion(nil, nil, error)
                }
            })
            task.resume()
        }
    }
}
