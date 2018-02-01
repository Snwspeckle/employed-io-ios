//
//  CommunicateVC.swift
//  Employed
//
//  Created by Anthony Vella on 11/12/17.
//  Copyright © 2017 Employed. All rights reserved.
//

import UIKit
import MessageKit

class CommunicateVC: MessagesViewController {

	// Some global variables for the sake of the example. Using globals is not recommended!
	let sender = Sender(id: "any_unique_id", displayName: "Steven")
	let messages: [MessageType] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

// MARK: - MessagesDataSource
extension CommunicateVC : MessagesDataSource {

	func currentSender() -> Sender {
		return Sender(id: "any_unique_id", displayName: "Steven")
	}

	func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
		return messages.count
	}

	func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
		return messages[indexPath.section]
	}
}
