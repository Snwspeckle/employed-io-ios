//
//  Utilities.swift
//  Employed
//
//  Created by Anthony Vella on 3/7/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import Foundation

// Helper to determine if we're running on simulator or device
struct PlatformUtils {
    static let isSimulator: Bool = {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }()
}

// Helper stuct to parse chat & video tokens from the token issuer.
struct TokenUtils {

	// The URL's for the chat & video token services
	enum SERVICE: String {
		case CHAT = "https://aurometalsaurus-frigatebird-8588.twil.io/chat-token"
		case VIDEO = "https://aurometalsaurus-frigatebird-8588.twil.io/video-token"
	}

	static func fetchChatToken(url: String, completion: @escaping (String?, String?, Error?) -> Void) {
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

	static func fetchVideoToken(url : String) throws -> String {
        var token: String = ""
		let requestURL: URL = URL(string: url)!
        do {
            let data = try Data(contentsOf: requestURL)
            if let tokenReponse = String.init(data: data, encoding: String.Encoding.utf8) {
                token = tokenReponse
            }
        } catch let error as NSError {
            print ("Invalid token url, error = \(error)")
            throw error
        }
        return token
    }
}

public extension Dictionary {
    public static func +=(lhs: inout [Key: Value], rhs: [Key: Value]) {
        rhs.forEach({ lhs[$0] = $1})
    }
}
