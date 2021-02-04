//
//  InAppDefaultBannerMessageHandler.swift
//  SwiftyInAppMessaging
//
//  Created by 伊藤史 on 2021/01/19.
//

import Foundation
import FirebaseInAppMessaging
import UIKit

struct InAppDefaultBannerMessageHandler: InAppBannerMessageHandler {
    let messageForDisplay: InAppMessagingBannerDisplay
    let displayDelegate: InAppMessagingDisplayDelegate

    init?(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) {
        guard let messageForDisplay = messageForDisplay as? InAppMessagingBannerDisplay else {
            return nil
        }

        self.messageForDisplay = messageForDisplay
        self.displayDelegate = displayDelegate
    }

    static func canHandleMessage(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) -> Bool {
        return messageForDisplay is InAppMessagingBannerDisplay
    }

    func displayMessage() {
        let bannerImage = try? UIImage(imageData: self.messageForDisplay.imageData)

        let bannerView = InAppDefaultBannerMessageView(title: self.messageForDisplay.title,
                                                       image: bannerImage,
                                                       bodyText: self.messageForDisplay.bodyText,
                                                       backgroundColor: self.messageForDisplay.displayBackgroundColor,
                                                       textColor: self.messageForDisplay.textColor,
                                                       actionURL: self.messageForDisplay.actionURL,
                                                       eventDetector: self)

        DispatchQueue.main.async {
            UIApplication.shared.topViewController?.view.addSubview(bannerView)
        }
    }

    func displayError(_ error: Error) {
        debugLog(error)
    }
}
