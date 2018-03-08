//
//  ChatVC.swift
//  Employed
//
//  Created by Anthony Vella on 3/3/18.
//  Copyright © 2018 Employed. All rights reserved.
//

import UIKit
import MessageKit
import TwilioChatClient

class ChatVC: MessagesViewController {
	
	// List of chat messages for MessageKit
    var chatMessages: [ChatMessage] = []
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Customize Navigation Bar
        self.navigationItem.title = "Tyrell Wellick"
		self.navigationController?.navigationBar.tintColor = UIColor.white
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "video-chat"), style: .plain, target: self, action: #selector(ChatVC.videoChatButtonPressed(_ :)))
		
		// Chat Service delegate setup
		ChatService.shared.delegate = self
		
		// MessageKit delegate setup
        messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesDisplayDelegate = self
		messagesCollectionView.messagesLayoutDelegate = self
		messageInputBar.delegate = self
		
		// Get the channels existing messages and convert them to ChatMessage objects
		ChatService.shared.getChannelMessages(completion: { (messages) in
			if let messages = messages {
				for message in messages {
					// Append the message to the chatMessages array
					self.chatMessages.append(self.buildChatMessage(message: message))
				}
			}
			
			// Reload the collection view and scroll to the bottom
			DispatchQueue.main.async {
				self.messagesCollectionView.reloadData()
				self.messagesCollectionView.scrollToBottom()
			}
		})
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
	}
	
	@objc func videoChatButtonPressed(_ sender: UIBarButtonItem) {
		let videoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier:"VideoVC") as! VideoVC
		self.navigationController?.pushViewController(videoVC, animated: true)
	}
	
	// Build the ChatMessage object from twilio data
	func buildChatMessage(message: TCHMessage) -> ChatMessage {
		let sender = Sender(id: message.author!, displayName: message.author!)
		let uniqueID = UUID().uuidString
		return ChatMessage(text: message.body!, sender: sender, messageId: uniqueID, date: message.timestampAsDate!)
	}
}

// MARK: Chat Service Delegate

extension ChatVC: ChatServiceDelegate {

	func didReceiveMessage(message: TCHMessage) {
		// Add the message to the list and reload the collection view
		chatMessages.append(buildChatMessage(message: message))
		messagesCollectionView.reloadData()
		messagesCollectionView.scrollToBottom()
	}
}

// MARK: - MessagesDataSource

extension ChatVC: MessagesDataSource {

    func currentSender() -> Sender {
        return Sender(id: ChatService.shared.getUserIdentity()!, displayName: ChatService.shared.getUserFriendlyName()!)
    }

    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatMessages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatMessages[indexPath.section]
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
		let text = NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
        return isFromCurrentSender(message: message) ? nil : text
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
		
        struct ConversationDateFormatter {
            static let formatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter
            }()
        }
        let formatter = ConversationDateFormatter.formatter
        let dateString = formatter.string(from: message.sentDate)
        let text = NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
        return isFromCurrentSender(message: message) ? nil : text
    }
}

// MARK: - MessagesDisplayDelegate

extension ChatVC: MessagesDisplayDelegate {

    // MARK: - Text Messages

    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }

    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey : Any] {
        return MessageLabel.defaultAttributes
    }

    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date]
    }

    // MARK: - All Messages
	
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
		return isFromCurrentSender(message: message) ? UIColor(named: "Red Background")! : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }

    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
//        let configurationClosure = { (view: MessageContainerView) in}
//        return .custom(configurationClosure)
    }
	
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
//        avatarView.set(avatar: avatar)
//    }
}

// MARK: - MessagesLayoutDelegate

extension ChatVC: MessagesLayoutDelegate {

    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
        return AvatarPosition(horizontal: .natural, vertical: .messageBottom)
    }
	
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
		return isFromCurrentSender(message: message) ? CGSize(width: 0.0, height: 0.0) : CGSize(width: 30.0, height: 30.0)
	}

    func messagePadding(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIEdgeInsets {
        if isFromCurrentSender(message: message) {
            return UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 4)
        } else {
            return UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 30)
        }
    }

    func cellTopLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        } else {
            return .messageLeading(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0))
        }
    }

    func cellBottomLabelAlignment(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LabelAlignment {
        if isFromCurrentSender(message: message) {
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        } else {
            return .messageTrailing(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
        }
    }

    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: messagesCollectionView.bounds.width, height: 10)
    }
	
    // MARK: - Location Messages

    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 200
    }

}

// MARK: - MessageInputBarDelegate

extension ChatVC: MessageInputBarDelegate {

    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
				let message = ChatMessage(text: text, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                chatMessages.append(message)
                messagesCollectionView.insertSections([chatMessages.count - 1])
				
				// Send the message to the chat service
                ChatService.shared.sendMessage(body: text)
            }
        }
		
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
}
