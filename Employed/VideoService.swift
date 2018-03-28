//
//  VideoService.swift
//  Employed
//
//  Created by Anthony Vella on 3/7/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import Foundation
import TwilioVideo

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
	
	func connect(room: String, audioTrack: TVILocalAudioTrack?, videoTrack: TVILocalVideoTrack?, delegate: TVIRoomDelegate!) -> TVIRoom? {
        // Configure and get the access token from the server
        var accessToken: String
        do {
        	let identity = getIdentity()
        	let urlString = "\(TokenUtils.SERVICE.VIDEO.rawValue)?identity=\(identity)&room=\(room)"
			accessToken = try TokenUtils.fetchVideoToken(url: urlString)
		} catch {
			print("Failed to fetch access token")
			return nil
		}
		
		// Preparing the connect options with the access token that we fetched (or hardcoded).
        let connectOptions = TVIConnectOptions.init(token: accessToken) { (builder) in
			
            // Use the local media that we prepared earlier.
			builder.audioTracks = audioTrack != nil ? [audioTrack!] : [TVILocalAudioTrack]()
            builder.videoTracks = videoTrack != nil ? [videoTrack!] : [TVILocalVideoTrack]()
			
            // Use the preferred audio codec
			builder.preferredAudioCodecs = [TVIAudioCodec.opus.rawValue]
			
            // Use the preferred video codec
			builder.preferredVideoCodecs =  [TVIVideoCodec.VP9.rawValue]
			
            // Use the preferred encoding parameters
            builder.encodingParameters = TVIEncodingParameters(audioBitrate: UInt(), videoBitrate: UInt())
			
            // The name of the Room where the Client will attempt to connect to. Please note that if you pass an empty
            // Room `name`, the Client will create one for you. You can get the name or sid from any connected Room.
            builder.roomName = room
        }
		
        return TwilioVideo.connect(with: connectOptions, delegate: delegate)
	}
}
