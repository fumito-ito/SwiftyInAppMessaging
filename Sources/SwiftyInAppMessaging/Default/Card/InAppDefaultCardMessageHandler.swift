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

    struct InAppDefaultCardMessageHandler: InAppCardMessageHandler {
        let messageForDisplay: InAppMessagingCardDisplay
        weak private(set) var displayDelegate: InAppMessagingDisplayDelegate?

        private static var window: UIWindow?

        init?(
            message messageForDisplay: InAppMessagingDisplayMessage,
            displayDelegate: InAppMessagingDisplayDelegate
        ) {
            guard let messageForDisplay = messageForDisplay as? InAppMessagingCardDisplay else {
                return nil
            }

            self.messageForDisplay = messageForDisplay
            self.displayDelegate = displayDelegate
        }

        static func canHandleMessage(
            message messageForDisplay: InAppMessagingDisplayMessage,
            displayDelegate: InAppMessagingDisplayDelegate
        ) -> Bool {
            return messageForDisplay.type == .card
        }

        func displayMessage() {
            do {
                guard
                    let portraitImage = try UIImage(
                        imageData: self.messageForDisplay.portraitImageData)
                else {
                    throw SwiftyInAppMessagingError.cardMessageWithoutPortraitImage
                }

                let landscapeImage = try? UIImage(
                    imageData: self.messageForDisplay.landscapeImageData)

                let viewController = InAppDefaultCardMessageViewController(
                    title: self.messageForDisplay.title,
                    portraitImage: portraitImage,
                    landscapeImage: landscapeImage,
                    bodyText: self.messageForDisplay.body,
                    primaryActionButton: self.messageForDisplay.primaryActionButton.asActionButton,
                    primaryActionURL: self.messageForDisplay.primaryActionURL,
                    secondaryActionButton: self.messageForDisplay.secondaryActionButton?
                        .asActionButton,
                    secondaryActionURL: self.messageForDisplay.secondaryActionURL,
                    backgroundColor: self.messageForDisplay.displayBackgroundColor,
                    textColor: self.messageForDisplay.textColor,
                    eventDetector: self)

                InAppDefaultCardMessageHandler.window = UIApplication.windowForMessage
                InAppDefaultCardMessageHandler.window?.rootViewController = viewController
                InAppDefaultCardMessageHandler.window?.isHidden = false
            } catch let error {
                self.displayError(error)
            }
        }

        func displayError(_ error: Error) {
            debugLog(error)
        }

        func messageDismissed(dismissType: FIRInAppMessagingDismissType) {
            self.displayDelegate?.messageDismissed?(
                self.messageForDisplay, dismissType: dismissType)
            self.dismissView()
        }

        func messageClicked(with action: InAppMessagingAction) {
            self.displayDelegate?.messageClicked?(self.messageForDisplay, with: action)
            self.dismissView()
        }

        private func dismissView() {
            InAppDefaultCardMessageHandler.window?.rootViewController?.dismissView()
            InAppDefaultCardMessageHandler.window = nil
        }
    }

    extension InAppDefaultCardMessageHandler {
        init?(message messageForDisplay: InAppMessagingDisplayMessage) {
            guard let messageForDisplay = messageForDisplay as? InAppMessagingCardDisplay else {
                return nil
            }

            self.messageForDisplay = messageForDisplay
        }
    }
#endif
