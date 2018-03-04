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

	// MARK: Twilio Chat variables
    var client: TwilioChatClient? = nil
    var generalChannel: TCHChannel? = nil
    var messages: [TCHMessage] = []
	
    var mkMessages: [ChatMessage] = []
	
	// TESTING CREATING RANDOM MESSAGE
    let uniqueID = NSUUID().uuidString
    let anthony = Sender(id: "656361", displayName: "Anthony")
    let john = Sender(id: "1234", displayName: "John")

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Customize Navigation Bar
        self.navigationItem.title = "Tyrell Wellick"
		self.navigationController?.navigationBar.tintColor = UIColor.white
		
        messagesCollectionView.messagesDataSource = self
		messagesCollectionView.messagesDisplayDelegate = self
		messagesCollectionView.messagesLayoutDelegate = self
		messageInputBar.delegate = self
		
        // TESTING CREATING RANDOM MESSAGE
		let testMessage1 = ChatMessage(text: "Current Sender", sender: anthony, messageId: uniqueID, date: Date())
		let testMessage2 = ChatMessage(text: "John Test", sender: john, messageId: uniqueID, date: Date())
		mkMessages.append(testMessage1)
		mkMessages.append(testMessage2)
    }
	
    override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		messagesCollectionView.reloadData()
		messagesCollectionView.scrollToBottom()
	}
}
	
// MARK: - MessagesDataSource

extension ChatVC: MessagesDataSource {

    func currentSender() -> Sender {
        return anthony
    }

    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return mkMessages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return mkMessages[indexPath.section]
    }

    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
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
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
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
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
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
            return .messageLeading(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
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
		
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
		
        for component in inputBar.inputTextView.components {
			
            if let text = component as? String {
				
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.blue])
				
                let message = ChatMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                mkMessages.append(message)
                messagesCollectionView.insertSections([mkMessages.count - 1])
            }
			
        }
		
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }

}
