//
//  ChatMessage.swift
//  Employed
//
//  Created by Anthony Vella on 3/4/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import MessageKit

/**
 ChatMessage is a wrapper for the MessageKit MessageType object
 */
struct ChatMessage: MessageType {

	var messageId: String
	var sender: Sender
	var sentDate: Date
	var data: MessageData
	
    init(data: MessageData, sender: Sender, messageId: String, date: Date) {
		self.data = data
		self.sender = sender
		self.messageId = messageId
		self.sentDate = date
	}
	
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(data: .text(text), sender: sender, messageId: messageId, date: date)
	}
	
	init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(data: .attributedText(attributedText), sender: sender, messageId: messageId, date: date)
	}
}
