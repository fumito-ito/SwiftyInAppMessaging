//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import Foundation
import FirebaseInAppMessaging

public protocol InAppMessageHandler: MessageDisplayable & MessageEventDetectable {
    var displayDelegate: InAppMessagingDisplayDelegate? { get }

    init?(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate)

    static func canHandleMessage(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) -> Bool
}

public protocol MessageDisplayable {
    func displayMessage()
    func displayError(_ error: Error)
}

public protocol MessageEventDetectable {
    func impressionDetected()
    func messageDismissed(dismissType: FIRInAppMessagingDismissType)
    func messageClicked(with action: InAppMessagingAction)
}

public protocol InAppModalMessageHandler: InAppMessageHandler {
    var messageForDisplay: InAppMessagingModalDisplay { get }
}

extension InAppModalMessageHandler {
    public func impressionDetected() {
        self.displayDelegate?.impressionDetected?(for: self.messageForDisplay)
    }

    public func messageDismissed(dismissType: FIRInAppMessagingDismissType) {
        self.displayDelegate?.messageDismissed?(self.messageForDisplay, dismissType: dismissType)
    }

    public func messageClicked(with action: InAppMessagingAction) {
        self.displayDelegate?.messageClicked?(self.messageForDisplay, with: action)
    }
}

public protocol InAppCardMessageHandler: InAppMessageHandler {
    var messageForDisplay: InAppMessagingCardDisplay { get }
}

extension InAppCardMessageHandler {
    public func impressionDetected() {
        self.displayDelegate?.impressionDetected?(for: self.messageForDisplay)
    }

    public func messageDismissed(dismissType: FIRInAppMessagingDismissType) {
        self.displayDelegate?.messageDismissed?(self.messageForDisplay, dismissType: dismissType)
    }

    public func messageClicked(with action: InAppMessagingAction) {
        self.displayDelegate?.messageClicked?(self.messageForDisplay, with: action)
    }
}

public protocol InAppBannerMessageHandler: InAppMessageHandler {
    var messageForDisplay: InAppMessagingBannerDisplay { get }
}

extension InAppBannerMessageHandler {
    public func impressionDetected() {
        self.displayDelegate?.impressionDetected?(for: self.messageForDisplay)
    }

    public func messageDismissed(dismissType: FIRInAppMessagingDismissType) {
        self.displayDelegate?.messageDismissed?(self.messageForDisplay, dismissType: dismissType)
    }

    public func messageClicked(with action: InAppMessagingAction) {
        self.displayDelegate?.messageClicked?(self.messageForDisplay, with: action)
    }
}

public protocol InAppImageOnlyMessageHandler: InAppMessageHandler {
    var messageForDisplay: InAppMessagingImageOnlyDisplay { get }
}

extension InAppImageOnlyMessageHandler {
    public func impressionDetected() {
        self.displayDelegate?.impressionDetected?(for: self.messageForDisplay)
    }

    public func messageDismissed(dismissType: FIRInAppMessagingDismissType) {
        self.displayDelegate?.messageDismissed?(self.messageForDisplay, dismissType: dismissType)
    }

    public func messageClicked(with action: InAppMessagingAction) {
        self.displayDelegate?.messageClicked?(self.messageForDisplay, with: action)
    }
}
