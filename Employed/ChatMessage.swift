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
    var kind: MessageKind
	var messageId: String
	var sender: Sender
	var sentDate: Date
	
    init(kind: MessageKind, sender: Sender, messageId: String, date: Date) {
        self.kind = kind
		self.sender = sender
		self.messageId = messageId
		self.sentDate = date
	}
	
    init(text: String, sender: Sender, messageId: String, date: Date) {
        self.init(kind: MessageKind.text(text), sender: sender, messageId: messageId, date: date)
	}
	
	init(attributedText: NSAttributedString, sender: Sender, messageId: String, date: Date) {
        self.init(kind: MessageKind.attributedText(attributedText), sender: sender, messageId: messageId, date: date)
	}
}
