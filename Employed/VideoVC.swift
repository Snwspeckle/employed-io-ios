//
//  VideoVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/7/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import TwilioVideo

class VideoVC: UIViewController {

	// Video SDK components
    var room: TVIRoom?
    var camera: TVICameraCapturer?
    var localVideoTrack: TVILocalVideoTrack?
    var localAudioTrack: TVILocalAudioTrack?
    var remoteParticipant: TVIRemoteParticipant?
    var remoteView: TVIVideoView?

	@IBOutlet weak var previewView: TVIVideoView!
	@IBOutlet var previewViewWidthConstraint: NSLayoutConstraint!
	@IBOutlet var previewViewHeightConstraint: NSLayoutConstraint!
	@IBOutlet var previewViewTopConstraint: NSLayoutConstraint!
	@IBOutlet var previewViewTrailingConstraint: NSLayoutConstraint!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		
        // Check if running on simulator to determine if video preview should be shown
		if PlatformUtils.isSimulator {
            self.previewView.removeFromSuperview()
        } else {
            // Preview our local camera track in the local video preview view.
            self.startPreview()
        }
		
		// Connect to the video room
        connect()
    }
	
    override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		// Disconnect from the video room
		self.room!.disconnect()
        logMessage(messageText: "Attempting to disconnect from room \(room!.name)")
	}
	
    func connect() {
    	// Prepare local media which we will share with Room Participants.
        self.prepareLocalMedia()
		
        // Connect to the video room
        if let room = VideoService.shared.connect(room: "test", audioTrack: self.localAudioTrack, videoTrack: self.localVideoTrack, delegate: self) {
        	self.room = room
        	logMessage(messageText: "Attempting to connect to room \(self.room!.name)")
		}
	}
	
    func startPreview() {
        if PlatformUtils.isSimulator {
            return
        }
		
		// Setup the preview video view with fullscreen constraints
        setupPreviewVideoView(isFullScreen: true)

        // Preview our local camera track in the local video preview view.
        camera = TVICameraCapturer(source: .frontCamera, delegate: self)
        localVideoTrack = TVILocalVideoTrack.init(capturer: camera!, enabled: true, constraints: nil, name: "Camera")
        if (localVideoTrack == nil) {
            logMessage(messageText: "Failed to create video track")
        } else {
            // Add renderer to video track for local preview
            localVideoTrack!.addRenderer(self.previewView)

            logMessage(messageText: "Video track created")
        }
    }
	
	// Sets the respectable constraints for the preview view depending on
	// if the view is in either fullscreen or non-fullscreen mode.
	func setupPreviewVideoView(isFullScreen: Bool) {
		// Remove all existing active contraints whose first item is the preview view
		for constraint in self.view.constraints {
			if ((constraint.firstItem as? TVIVideoView == self.previewView!) && constraint.isActive) {
				constraint.isActive = false
			}
		}
		
		if (isFullScreen) {
			// Style the preview view without rounded corners
			self.previewView.layer.masksToBounds = false
			self.previewView.layer.cornerRadius = 0
			
			// Set the fullscreen constraints for the preview view
			setFullScreenConstraints(videoView: self.previewView!)
		} else {
			// Style the preview view with rounded corners
			self.previewView.layer.masksToBounds = true
			self.previewView.layer.cornerRadius = 4
			
			// Activate the non-fullscreen constraints
			self.previewViewWidthConstraint.isActive = true
			self.previewViewHeightConstraint.isActive = true
			self.previewViewTopConstraint.isActive = true
			self.previewViewTrailingConstraint.isActive = true
		}
		
		// Animate the constraint changes
		UIView.animate(withDuration: 0.30, delay: 0.0, options: .curveEaseInOut, animations: {
			self.view.layoutIfNeeded()
		}, completion: nil)
	}
	
    func setupRemoteVideoView() {
        // Creating `TVIVideoView` programmatically
        self.remoteView = TVIVideoView.init(frame: CGRect.zero, delegate:self)
		
        self.view.insertSubview(self.remoteView!, at: 0)
		
        // `TVIVideoView` supports scaleToFill, scaleAspectFill and scaleAspectFit
        // scaleAspectFit is the default mode when you create `TVIVideoView` programmatically.
        self.remoteView!.contentMode = .scaleAspectFill;
		setFullScreenConstraints(videoView: self.remoteView!)
    }
	
	// Helper function to set a video views constraints to fill the full screen
    func setFullScreenConstraints(videoView: TVIVideoView) {
		videoView.translatesAutoresizingMaskIntoConstraints =  false
		NSLayoutConstraint(item: videoView,
										 attribute: NSLayoutAttribute.centerX,
										 relatedBy: NSLayoutRelation.equal,
										 toItem: self.view,
										 attribute: NSLayoutAttribute.centerX,
										 multiplier: 1,
										 constant: 0).isActive = true;
		NSLayoutConstraint(item: videoView,
										 attribute: NSLayoutAttribute.centerY,
										 relatedBy: NSLayoutRelation.equal,
										 toItem: self.view,
										 attribute: NSLayoutAttribute.centerY,
										 multiplier: 1,
										 constant: 0).isActive = true;
		NSLayoutConstraint(item: videoView,
									   attribute: NSLayoutAttribute.width,
									   relatedBy: NSLayoutRelation.equal,
									   toItem: self.view,
									   attribute: NSLayoutAttribute.width,
									   multiplier: 1,
									   constant: 0).isActive = true;
		NSLayoutConstraint(item: videoView,
										attribute: NSLayoutAttribute.height,
										relatedBy: NSLayoutRelation.equal,
										toItem: self.view,
										attribute: NSLayoutAttribute.height,
										multiplier: 1,
										constant: 0).isActive = true;
	}
	
    func prepareLocalMedia() {

        // We will share local audio and video when we connect to the Room.

        // Create an audio track.
        if (localAudioTrack == nil) {
            localAudioTrack = TVILocalAudioTrack.init(options: nil, enabled: true, name: "Microphone")

            if (localAudioTrack == nil) {
                logMessage(messageText: "Failed to create audio track")
            }
        }

        // Create a video track which captures from the camera.
        if (localVideoTrack == nil) {
            self.startPreview()
        }
   }
	
	func cleanupRemoteParticipant() {
		if ((self.remoteParticipant) != nil) {
			if ((self.remoteParticipant?.videoTracks.count)! > 0) {
				let remoteVideoTrack = self.remoteParticipant?.remoteVideoTracks[0].remoteTrack
                remoteVideoTrack?.removeRenderer(self.remoteView!)
                self.remoteView?.removeFromSuperview()
                self.remoteView = nil
            }
        }
        self.remoteParticipant = nil
    }
	
    func logMessage(messageText: String) {
    	print(messageText)
    }
}

// MARK: TVIRoomDelegate
extension VideoVC : TVIRoomDelegate {
    func didConnect(to room: TVIRoom) {
		
        // At the moment, this example only supports rendering one Participant at a time.
		
        logMessage(messageText: "Connected to room \(room.name) as \(String(describing: room.localParticipant?.identity))")
		
        if (room.remoteParticipants.count > 0) {
            self.remoteParticipant = room.remoteParticipants[0]
            self.remoteParticipant?.delegate = self
			
            // Set the preview video view to not be fullscreen because the participant connected
			setupPreviewVideoView(isFullScreen: false)
        }
    }
	
    func room(_ room: TVIRoom, didDisconnectWithError error: Error?) {
        logMessage(messageText: "Disconncted from room \(room.name), error = \(String(describing: error))")
		
        self.cleanupRemoteParticipant()
        self.room = nil
    }
	
    func room(_ room: TVIRoom, didFailToConnectWithError error: Error) {
        logMessage(messageText: "Failed to connect to room with error")
        self.room = nil
    }
	
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
		if (self.remoteParticipant == nil) {
            self.remoteParticipant = participant
            self.remoteParticipant?.delegate = self
			
            // Set the preview video view to not be fullscreen because the participant connected
			setupPreviewVideoView(isFullScreen: false)
        }
		
		logMessage(messageText: "Participant \(participant.identity) connected with \(participant.remoteAudioTracks.count) audio and \(participant.remoteVideoTracks.count) video tracks")
    }
	
    func room(_ room: TVIRoom, participantDidDisconnect participant: TVIRemoteParticipant) {
        if (self.remoteParticipant == participant) {
            cleanupRemoteParticipant()
        }
        // Set the preview video view to be fullscreen because our participant disconnected
        setupPreviewVideoView(isFullScreen: true)
		
        logMessage(messageText: "Room \(room.name), Participant \(participant.identity) disconnected")
    }
}

// MARK: TVIRemoteParticipantDelegate
extension VideoVC : TVIRemoteParticipantDelegate {
	
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
		
        // Remote Participant has offered to share the video Track.
		
        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) video track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedVideoTrack publication: TVIRemoteVideoTrackPublication) {
		
        // Remote Participant has stopped sharing the video Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) video track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           publishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
		
        // Remote Participant has offered to share the audio Track.

        logMessage(messageText: "Participant \(participant.identity) published \(publication.trackName) audio track")
    }

    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           unpublishedAudioTrack publication: TVIRemoteAudioTrackPublication) {
		
        // Remote Participant has stopped sharing the audio Track.

        logMessage(messageText: "Participant \(participant.identity) unpublished \(publication.trackName) audio track")
    }

   func subscribed(to videoTrack: TVIRemoteVideoTrack,
                    publication: TVIRemoteVideoTrackPublication,
                    for participant: TVIRemoteParticipant) {
	
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's video frames now.
	
        logMessage(messageText: "Subscribed to \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == participant) {
            setupRemoteVideoView()
            videoTrack.addRenderer(self.remoteView!)
        }
    }
	
    func unsubscribed(from videoTrack: TVIRemoteVideoTrack,
                      publication: TVIRemoteVideoTrackPublication,
                      for participant: TVIRemoteParticipant) {
		
        // We are unsubscribed from the remote Participant's video Track. We will no longer receive the
        // remote Participant's video.
		
        logMessage(messageText: "Unsubscribed from \(publication.trackName) video track for Participant \(participant.identity)")

        if (self.remoteParticipant == participant) {
            videoTrack.removeRenderer(self.remoteView!)
            self.remoteView?.removeFromSuperview()
            self.remoteView = nil
        }
    }
	
    func subscribed(to audioTrack: TVIRemoteAudioTrack,
                    publication: TVIRemoteAudioTrackPublication,
                    for participant: TVIRemoteParticipant) {
		
        // We are subscribed to the remote Participant's audio Track. We will start receiving the
        // remote Participant's audio now.
		
        logMessage(messageText: "Subscribed to \(publication.trackName) audio track for Participant \(participant.identity)")
    }
	
    func unsubscribed(from audioTrack: TVIRemoteAudioTrack,
                      publication: TVIRemoteAudioTrackPublication,
                      for participant: TVIRemoteParticipant) {
		
        // We are unsubscribed from the remote Participant's audio Track. We will no longer receive the
        // remote Participant's audio.
		
        logMessage(messageText: "Unsubscribed from \(publication.trackName) audio track for Participant \(participant.identity)")
    }
	
   func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) video track")
    }
	
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledVideoTrack publication: TVIRemoteVideoTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) video track")
    }
	
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           enabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) enabled \(publication.trackName) audio track")
    }
	
    func remoteParticipant(_ participant: TVIRemoteParticipant,
                           disabledAudioTrack publication: TVIRemoteAudioTrackPublication) {
        logMessage(messageText: "Participant \(participant.identity) disabled \(publication.trackName) audio track")
    }

    func failedToSubscribe(toAudioTrack publication: TVIRemoteAudioTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) audio track, error = \(String(describing: error))")
    }

    func failedToSubscribe(toVideoTrack publication: TVIRemoteVideoTrackPublication,
                           error: Error,
                           for participant: TVIRemoteParticipant) {
        logMessage(messageText: "FailedToSubscribe \(publication.trackName) video track, error = \(String(describing: error))")
    }
}

// MARK: TVIVideoViewDelegate
extension VideoVC : TVIVideoViewDelegate {
    func videoView(_ view: TVIVideoView, videoDimensionsDidChange dimensions: CMVideoDimensions) {
        self.view.setNeedsLayout()
    }
}

// MARK: TVICameraCapturerDelegate
extension VideoVC : TVICameraCapturerDelegate {
    func cameraCapturer(_ capturer: TVICameraCapturer, didStartWith source: TVICameraCaptureSource) {
        self.previewView.shouldMirror = (source == .frontCamera)
    }
}
