//
//  InAppDefaultBannerMessageHandler.swift
//  SwiftyInAppMessaging
//
//  Created by 伊藤史 on 2021/01/19.
//

#if os(iOS) || os(tvOS)
    import FirebaseInAppMessaging
    import Foundation
    import UIKit

    struct InAppDefaultBannerMessageHandler: InAppBannerMessageHandler {
        let messageForDisplay: InAppMessagingBannerDisplay
        weak private(set) var displayDelegate: InAppMessagingDisplayDelegate?

        private static var window: UIWindow?

        init(message messageForDisplay: InAppMessagingBannerDisplay) {
            self.messageForDisplay = messageForDisplay
        }

        func displayMessage(with delegate: InAppMessagingDisplayDelegate) {
            let bannerImage = try? UIImage(imageData: self.messageForDisplay.imageData)

            let viewController = InAppDefaultBannerMessageViewController(
                title: self.messageForDisplay.title,
                image: bannerImage,
                bodyText: self.messageForDisplay.bodyText,
                backgroundColor: self.messageForDisplay.displayBackgroundColor,
                textColor: self.messageForDisplay.textColor,
                actionURL: self.messageForDisplay.actionURL,
                eventDetector: self)

            InAppDefaultBannerMessageHandler.window = UIApplication.windowForBanner
            InAppDefaultBannerMessageHandler.window?.rootViewController = viewController
            InAppDefaultBannerMessageHandler.window?.isHidden = false
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
            InAppDefaultBannerMessageHandler.window?.rootViewController?.dismissView()
            InAppDefaultBannerMessageHandler.window = nil
        }
    }

    extension InAppDefaultBannerMessageHandler {
        init?(message messageForDisplay: InAppMessagingDisplayMessage) {
            guard let messageForDisplay = messageForDisplay as? InAppMessagingBannerDisplay else {
                return nil
            }

            self.messageForDisplay = messageForDisplay
        }
    }
#endif
