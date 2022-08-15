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

    struct InAppDefaultImageOnlyMessageHandler: InAppImageOnlyMessageHandler {
        let messageForDisplay: InAppMessagingImageOnlyDisplay
        weak private(set) var displayDelegate: InAppMessagingDisplayDelegate?

        private static var window: UIWindow?

        init(message messageForDisplay: InAppMessagingImageOnlyDisplay) {
            self.messageForDisplay = messageForDisplay
        }

        func displayMessage(with delegate: InAppMessagingDisplayDelegate) throws {
            let image = try UIImage(imageData: self.messageForDisplay.imageData)
            let viewController = InAppDefaultImageOnlyMessageViewController(
                image: image,
                actionURL: self.messageForDisplay.actionURL,
                eventDetector: self)

            InAppDefaultImageOnlyMessageHandler.window = UIApplication.windowForMessage
            InAppDefaultImageOnlyMessageHandler.window?.rootViewController = viewController
            InAppDefaultImageOnlyMessageHandler.window?.isHidden = false
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
            InAppDefaultImageOnlyMessageHandler.window?.rootViewController?.dismissView()
            InAppDefaultImageOnlyMessageHandler.window = nil
        }
    }
#endif
