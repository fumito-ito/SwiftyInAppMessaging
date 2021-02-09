//
//  File.swift
//  
//
//  Created by 伊藤史 on 2021/01/05.
//

import FirebaseInAppMessaging
import Foundation
import UIKit

struct InAppDefaultModalMessageHandler: InAppModalMessageHandler {
    let messageForDisplay: InAppMessagingModalDisplay
    weak var displayDelegate: InAppMessagingDisplayDelegate?

    init?(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) {
        guard let messageForDisplay = messageForDisplay as? InAppMessagingModalDisplay else {
            return nil
        }

        self.messageForDisplay = messageForDisplay
        self.displayDelegate = displayDelegate
    }

    static func canHandleMessage(message messageForDisplay: InAppMessagingDisplayMessage, displayDelegate: InAppMessagingDisplayDelegate) -> Bool {
        return messageForDisplay is InAppMessagingModalDisplay
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

            DispatchQueue.main.async {
                viewController.setupConstraints()
                UIApplication.shared.topViewController?.present(viewController, animated: true, completion: nil)
            }
        } catch let error {
            self.displayError(error)
        }
    }

    func displayError(_ error: Error) {
        debugLog(error)
    }
}
