//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//
#if os(iOS) || os(tvOS)
import FirebaseInAppMessaging
import Foundation
import UIKit

struct InAppDefaultModalMessageHandler: InAppModalMessageHandler {
    let messageForDisplay: InAppMessagingModalDisplay
    weak private(set) var displayDelegate: InAppMessagingDisplayDelegate?

    private static var window: UIWindow?

    init?(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) {
        guard let messageForDisplay = messageForDisplay as? InAppMessagingModalDisplay else {
            return nil
        }

        self.messageForDisplay = messageForDisplay
        self.displayDelegate = displayDelegate
    }

    static func canHandleMessage(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) -> Bool {
        return messageForDisplay.type == .modal
    }

    func displayMessage() {
        do {
            let image = try UIImage(imageData: self.messageForDisplay.imageData)
            let viewController = InAppDefaultModalMessageViewController(title: self.messageForDisplay.title,
                                                                        image: image,
                                                                        bodyText: self.messageForDisplay.bodyText,
                                                                        actionButton: self.messageForDisplay.actionButton?.asActionButton,
                                                                        actionURL: self.messageForDisplay.actionURL,
                                                                        backgroundColor: self.messageForDisplay.displayBackgroundColor,
                                                                        textColor: self.messageForDisplay.textColor,
                                                                        eventDetector: self)

            InAppDefaultModalMessageHandler.window = UIApplication.windowForMessage
            InAppDefaultModalMessageHandler.window?.rootViewController = viewController
            InAppDefaultModalMessageHandler.window?.isHidden = false
        } catch let error {
            self.displayError(error)
        }
    }

    func displayError(_ error: Error) {
        debugLog(error)
    }

    public func messageDismissed(dismissType: FIRInAppMessagingDismissType) {
        self.displayDelegate?.messageDismissed?(self.messageForDisplay, dismissType: dismissType)
        self.dismissView()
    }

    public func messageClicked(with action: InAppMessagingAction) {
        self.displayDelegate?.messageClicked?(self.messageForDisplay, with: action)
        self.dismissView()
    }

    private func dismissView() {
        InAppDefaultModalMessageHandler.window?.rootViewController?.dismissView()
        InAppDefaultModalMessageHandler.window = nil
    }
}

extension InAppDefaultModalMessageHandler {
    init?(message messageForDisplay: InAppMessagingDisplayMessage) {
        guard let messageForDisplay = messageForDisplay as? InAppMessagingModalDisplay else {
            return nil
        }

        self.messageForDisplay = messageForDisplay
    }
}
#endif
